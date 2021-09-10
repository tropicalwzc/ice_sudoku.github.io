import torch
import torchvision
import torchvision.transforms as transforms
from ADV_ResNet import *
import torch.nn as nn
import matplotlib.pyplot as plt
import numpy as np
from torchvision.datasets import ImageFolder
from torch.utils.data import DataLoader, Dataset, random_split
import coremltools as ct
# mean and std of cifar10 in 3 channels
cifar10_mean = (0.49, 0.48, 0.45)
cifar10_std = (0.25, 0.24, 0.26)

# define transform operations of train dataset
train_transform = transforms.Compose([
    # data augmentation
    transforms.Pad(4),
    transforms.RandomHorizontalFlip(),
    transforms.RandomCrop(32),
    transforms.ToTensor(),
    transforms.Normalize(cifar10_mean, cifar10_std)])

test_transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize(cifar10_mean, cifar10_std)])


transform = transforms.Compose(
    [
        transforms.Resize((80,80)),
        transforms.RandomRotation(20),
        transforms.RandomCrop((64,64),padding=4),
        # transforms.Grayscale(3),
        transforms.ColorJitter(brightness=0.5, contrast=0.5, saturation=0.5, hue=0.5),
        transforms.ToTensor(),
        transforms.Normalize((0.485,0.456,0.406),(0.229,0.224,0.225))
    ])

BATCH_SIZE = 1000
dataset1 = ImageFolder("Merge", transform=transform)
dataset2 = ImageFolder("Coloring", transform=transform)
# mini train Cifar10 datasets: 1000 images each class
# train_dataset = torchvision.datasets.ImageFolder(root='./data/path2cifar10/train', transform=train_transform)
# mini test Cifar10 datasets: 500 images each class
# test_dataset = torchvision.datasets.ImageFolder(root='./data/path2cifar10/test', transform=test_transform)
totaldatasetsize = len(dataset1)
use_for_train_num = int(totaldatasetsize/6*5)
use_for_test_num = totaldatasetsize - use_for_train_num
train_dataset, _ = random_split(dataset1, [use_for_train_num,use_for_test_num])

totaldatasetsize2 = len(dataset2)
use_for_train_num2 = int(totaldatasetsize2/2)
use_for_test_num2 = totaldatasetsize2 - use_for_train_num2
_, test_dataset = random_split(dataset2, [use_for_train_num2,use_for_test_num2])

train_loader = torch.utils.data.DataLoader(dataset=train_dataset,
                                           batch_size=BATCH_SIZE,
                                           num_workers=1,
                                           shuffle=True)

test_loader = torch.utils.data.DataLoader(dataset=test_dataset,
                                          batch_size=BATCH_SIZE,
                                          num_workers=1,
                                          shuffle=False)

# LEARNING_RATE = 1e-4
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
# loss = nn.CrossEntropyLoss()
# print ("Loading pretrained data")
model = resnet34(pretrained=True) # Basic_CNN().to(device=DEVICE)
model.fc = nn.Linear(512, 10)
model = model.half()
model = model.cuda()
# optimizer = torch.optim.SGD(model.parameters(),lr=LEARNING_RATE,momentum=0.9,weight_decay=0.001)

def train(model, train_loader, loss_func, optimizer, device):
    """
    train model using loss_fn and optimizer in an epoch.
    model: CNN networks
    train_loader: a Dataloader object with training data
    loss_func: loss function
    device: train on cpu or gpu device
    """
    total_loss = 0
    # train the model using minibatch
    for i, (images, targets) in enumerate(train_loader):
        images = images.half()
        images = images.to(device)
        targets = targets.to(device)

        # forward
        outputs = model(images)
        loss = loss_func(outputs, targets)

        # backward and optimize
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        total_loss += loss.item()

        # every 100 iteration, print loss
        if (i + 1) % 100 == 0:
            print("Step [{}/{}] Train Loss: {:.4f}"
                  .format(i + 1, len(train_loader), loss.item()))
    return total_loss / len(train_loader)


def evaluate(model, val_loader, device):
    """
    model: CNN networks
    val_loader: a Dataloader object with validation data
    device: evaluate on cpu or gpu device
    return classification accuracy of the model on val dataset
    """
    # evaluate the model
    model.eval()
    # context-manager that disabled gradient computation
    with torch.no_grad():
        correct = 0
        total = 0

        for i, (images, targets) in enumerate(val_loader):
            # device: cpu or gpu
            images = images.half()
            images = images.to(device)
            targets = targets.to(device)

            outputs = model(images)

            # return the maximum value of each row of the input tensor in the
            # given dimension dim, the second return vale is the index location
            # of each maxium value found(argmax)
            _, predicted = torch.max(outputs.data, dim=1)

            correct += (predicted == targets).sum().item()

            total += targets.size(0)

        accuracy = correct / total
        print('Accuracy on Test Set: {:.4f} %'.format(100 * accuracy))
        return accuracy

def show_curve(ys, title):
    """
    plot curlve for Loss and Accuacy
    Args:
        ys: loss or acc list
        title: loss or accuracy
    """
    x = np.array(range(len(ys)))
    y = np.array(ys)
    plt.plot(x, y, c='b')
    plt.axis()
    plt.title('{} curve'.format(title))
    plt.xlabel('epoch')
    plt.ylabel('{}'.format(title))
    plt.show()


def fit(model, num_epochs, optimizer, device):
    """
     train and evaluate an classifier num_epochs times.
    n and evaluate an classifier num_epochs times.
    We use optimizer and cross entropy loss to train the model.
    Args:
        model: CNN network
        num_epochs: the number of training epochs
        optimizer: optimize the loss function    loss_func.to(device)
    loss_func.to(device)

    """
    maxacc = 0
    # loss and optimizer
    loss_func = nn.CrossEntropyLoss()

    model.to(device)
    loss_func.to(device)

    # log train loss and test accuracy
    losses = []
    accs = []

    mid = num_epochs/2

    for epoch in range(num_epochs):
        print('Epoch {}/{}:'.format(epoch + 1, num_epochs))
        # train step
        if epoch > mid:
            optimizer1 = torch.optim.SGD(model.parameters(), lr=0.0002, momentum=0.9, weight_decay=0.001)
            loss = train(model, train_loader, loss_func, optimizer1, device)
        else:
            loss = train(model, train_loader, loss_func, optimizer, device)
        losses.append(loss)

        # evaluate step
        accuracy = evaluate(model, test_loader, device)
        if accuracy > maxacc:
            maxacc = accuracy
            torch.save(model, "current_best.pth")

        accs.append(accuracy)
        if(epoch%20 ==19 ):
            torch.save(model, "mid_{0}.pth".format(epoch))

    torch.save(model, "latest_model.pth")
    # show curve
    show_curve(losses, "train loss")
    show_curve(accs, "test accuracy")

if __name__ == '__main__':
    # train(model,train_loader,loss,optimizer,DEVICE)

    num_epochs = int(use_for_train_num / BATCH_SIZE)*2
    lr = 0.001
        # Device configuration
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        # optimizer
    optimizer = torch.optim.SGD(model.parameters(), lr=0.0005, momentum=0.9, weight_decay=0.001) #torch.optim.Adam(model.parameters(), lr=lr)

    fit(model, num_epochs, optimizer, DEVICE)


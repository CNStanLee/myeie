# config terminal
# ctrl shift p
# Terminal:Select default profile

# Creator: Changhong Li
# Email: lic9@tcd.ie

print("hello world")

myName = "Changhong Li"
myAge  = 25
pi = 3.1415926
student = True
uniYears = [2015, 2016, 2017]
print(myName)
print(myAge)
print(type(uniYears))

# arr starts from 0

# struc

captials = {
    "Trinidad" : "Port-of-Spain",
    "Ireland" : "Dublin"
}

print(captials["Ireland"])

# control seq

a = 100
b = 200

if b > a:
        print("b is larger")
elif a == b:
        print("2")

# https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf

# conda create --name pyTut python=3
# conda activate pyTut

# pip install pipreqs
# pipreqs . 
# pip install numpy

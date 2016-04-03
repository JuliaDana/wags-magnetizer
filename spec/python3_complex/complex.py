script_var = "This is a script or global level variable"

# Print the fibonacci number up to n
n = 10
a, b = 0, 1
while b < n:
  print(b)
  a, b = b, a + b

# A dog class
class Dog:
  def __init__(self, name):
    self.name = name

  def speak(self):
    print(self.name + " says woof.")

d = Dog("Fido")
d.speak()

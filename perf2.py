from timeit import Timer

setup1 = """
from swapcontext import greenlet
def f1():
    while True:
        greenlet.getcurrent().parent.switch()
g = greenlet(f1)
"""

setup2 = """
from py.magic import greenlet
def f1():
    while True:
        greenlet.getcurrent().parent.switch()
g = greenlet(f1)
"""

code = """
g.switch()
g.switch()
g.switch()
g.switch()
g.switch()
"""

print "   greenlet", Timer(code, setup2).timeit(10000)
print "swapcontext", Timer(code, setup1).timeit(10000)


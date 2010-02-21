from timeit import Timer

setup1 = "from swapcontext import greenlet"
setup2 = "from py.magic import greenlet"

code = """
def f1():
    greenlet.getcurrent().parent.switch()
    greenlet.getcurrent().parent.switch()
    greenlet.getcurrent().parent.switch()
    greenlet.getcurrent().parent.switch()

g = greenlet(f1)
g.switch()
g.switch()
g.switch()
g.switch()
g.switch()
"""

print "   greenlet", Timer(code, setup2).timeit(10000)
print "swapcontext", Timer(code, setup1).timeit(10000)


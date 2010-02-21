from pyst import greenlet
#from py.magic import greenlet

def f1():
    print "oh hai"
    greenlet.getcurrent().parent.switch()
    print "you"

g = greenlet(f1)
g.switch()
print "there"
g.switch()
print "."


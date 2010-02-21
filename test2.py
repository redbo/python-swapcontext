from pyst import greenlet

def f2():
    print "2"

def f1():
    print "1"
    g2.switch()
    print "3"

g = greenlet(f1)
g2 = greenlet(f2)
g.switch()
print "4"


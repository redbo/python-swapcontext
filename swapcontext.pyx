DEFAULT_STACK_SIZE = (1024 * 128)

cdef extern from "stdlib.h":
    void free(void *ptr)
    void *malloc(unsigned long size)

cdef extern from "ucontext.h":
    struct stack_t:
        void *ss_sp
        unsigned long ss_size

    struct ucontext:
        stack_t          uc_stack

    void makecontext(ucontext *ucp, void (*func)(), int argc)
    int swapcontext(ucontext *oucp, ucontext *ucp)
    int getcontext(ucontext *ucp)

cdef void _entry():
    _func()
    _current.parent.switch()

cdef class greenlet:
    cdef ucontext _context
    cdef public object parent
    cdef object _func

    def __init__(self, func, stack_size=DEFAULT_STACK_SIZE):
        self.parent = _current
        self._func = func
        getcontext(&self._context)
        self._context.uc_stack.ss_sp = malloc(stack_size)
        self._context.uc_stack.ss_size = stack_size
        makecontext(&self._context, <void (*)()>_entry, 0)

    def switch(self):
        global _current, _func
        old = _current
        _current = self
        if self._func:
            _func = self._func
            self._func = None
        swapcontext(&(<greenlet>old)._context, &self._context)

    def __del__(self):
        if self._context.uc_stack.ss_sp != NULL:
            free(self._context.uc_stack.ss_sp)

    def getcurrent(cls):
        return _current
    getcurrent = classmethod(getcurrent)

cdef object _func = None
cdef object _current = None
_current = greenlet(None)


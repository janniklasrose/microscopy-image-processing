#@String sourcedir
#@String targetdir
#@String transfdir
#@String reference

from register_virtual_stack import Register_Virtual_Stack_MT

# hard coded options
use_shrinking_constraint = 0
p = Register_Virtual_Stack_MT.Param()

print("register_virtual_stack: Starting")

# call function
Register_Virtual_Stack_MT.exec(
    sourcedir, targetdir, transfdir, reference,
    p, use_shrinking_constraint,
)

print("register_virtual_stack: Complete")

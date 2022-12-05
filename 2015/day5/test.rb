test = "abxxabyzyzzab"

print /(.).\1/.match(test)
print "\n"
print /(..).*\1/.match(test)[0]

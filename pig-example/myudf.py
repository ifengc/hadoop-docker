import re
@outputSchema('grade:int')
def idNew(grade):
    match = re.search(r'\d+', str(grade))
    if match:
        newGrade = int(match.group()) + 5
    return newGrade

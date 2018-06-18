These exercises are based on the problems found in the project codility website: https://www.hackerrank.com/

## Used Technologies

**1. Java version 8.**

**2. JUnit.**

## Considerations

**Tests:** The tests are defined under the com.test package.

## Problems

###### [Challenge](https://www.hackerrank.com/challenges/lisa-workbook/problem) 

### Lisa's Workbook
```
Lisa just got a new math workbook. A workbook contains exercise problems, grouped into chapters. Lisa believes a problem to be special if its index (within a chapter) is the same as the page number where it's located. The format of Lisa's book is as follows:

There are  chapters in Lisa's workbook, numbered from  to .
The  chapter has  problems, numbered from  to .
Each page can hold up to  problems. Only a chapter's last page of exercises may contain fewer than  problems.
Each new chapter starts on a new page, so a page will never contain problems from more than one chapter.
The page number indexing starts at .

Given the details for Lisa's workbook, can you count its number of special problems?

For example, Lisa's workbook contains arr[i] = 4 problems for chapter 1, and arr[2] = 2 problems for chapter 2. Each page can hold k = 3 problems. The first page will hold 3 problems for chapter 1. Problem 1 is on page 1, so it is special. Page 2 contains only Chapter 1, Problem 4, so no special problem is on page 2. Chapter  problems start on page 3 and there are 2 problems. Since there is no problem 3 on page 3, there is no special problem on that page either. There is 1 special problem in her workbook.
```  

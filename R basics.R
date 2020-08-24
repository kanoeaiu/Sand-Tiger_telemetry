###############################R prompts####################################

> # means that R is ready for a new command
+ # means that R is waiting for you to finish the current command
  
#############################Help within R environment#########################

help(function name) #explanation of inputs and outputs of each function including examples
?[function name] # same as help (ex. ?min)
??[function name or keyword] # broader search including functions within packages you do not have installed, or pieces of function names (ex. ??min)

################################Stopping R##################################

#ctrl-c or esc 
#stop sign in RStudio

q() #exits R
# This will ask if you want to save workspace (contains objects created), generally, you save the script and re-run it to recreate objects so you don’t need to save workspace 

############################Common arithmetic operators#######################

3+2 	# + # adding
3-2 	# - # subtracting
3/2 	# / # dividing
3*2 	# * # multiplying
3^2 	# ^ # exponent


#############################Common logical operators#########################

3<2 	# < # less than
3<=2	 # <= # less than or equal to
3>2 	# > # greater than
3>=2 	# >= # greater than or equal to
3==2 	# == # exactly equal

3!=2       # != # not equal to

##################################Vectors##################################
#vector is the simplest type of data structure in R. It is a single entity consisting of a collection of things

###############################Creating vectors###############################

#Example 1
c(1,2,5.3,6,-2,4) #numeric vector
a1 <- c(1,2,5.3,6,-2,4) #assign numeric vector to object “a1”
length(a1) #length() returns the number of values in object a1
summary(a1) #summary() returns summary statistics of object, in the case of a numeric vector, the minimum, maximum, median, mead, 1st and 3rd quartiles.
table(a1) #table() tabulates counts for each value level

#Example 2
b <- c("one","two","three", "four", "five", "six") # vector of characters assigned to object “b”
length(b)
summary(b)
table(b)

#Example 3
c <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE) #logical vector
length(c)
summary(c)
table(c)

d <- 1:6 #semi-colon is shorthand for creating a series

e <- seq(1, 6, by=1) #seq() creates a sequence vector between the first and second number, in this case by 1’s 

f <- rep(1:4, times = 6) #rep() creates a vector that repeats a number, or sequence or series of numbers the selected number of times 
table(f)
g <- rep(1:4, each = 6) 
table(g)

a1+b #produces error because of data type mismatch (numeric vs character)
a1+c

a2 <- c(.0001, .001, .01, .1, 1, 10)

a1+a2
a1-a2
a1/a2
a1*a2
a1^a2

a1<a2
a1<=a2
a1>a1
a1>=a2
a1==a2
a1!=a2

a1[c(2,4)] # 2nd and 4th elements of vector
a1[5] ###5th element in vector

###########################Commands for creating indices#######################
which(a1>3) #produces the index of values that satisfy the logical test
a1[which(a1>3)] #indexes the vector a1 where the values satisfy the logical test

match(a1, a2) ###gives a row index in a2 for each element of a1
match(a2, a1) ###gives a row index in a1 for each element of a2

a1 %in% a2 ###logical test to tell you if an element in a1 is present in a2
a2 %in% a1 ###logical test to tell you if an element in a2 is present in a1

a1[a1 %in% a2] ####same as using which command
a2[a2 %in% a1] ####same as using which command

##############################Common statistical functions######################

mean(a2) #mean 
sd(a2) #standard deviation
var(a2) #variance 
min(a2) #minimum value of an object
max(a2) #maximum value of an object
range(a2) #range of values in an object

sin(a2) #many other trig functions see ?sin
cos(a2)
log10(a2) #log base 10
log(a2) #natural log
exp(a2) #exponential function

sum(a2) #sum of values in vector a2
cumsum(a2) #cumulative sum
cumprod(a2) #cumulative product
cummin(a2) #cumulative minima
cummax(a2) #cumulative maxima

ls() #lists all objects that have been created in current R console
#rm(list=ls()) #removing all objects that have been created in current R console

##################################Matrices###################################
#A matrix is a collection of data elements arranged in a two-dimensional rectangular layout

#############################Creating matrices################################

Example 1
cbind(a1, a2, a1, a2) #creating a matrix by binding columns, using cbind()
rbind(a2, a1, a2, a1) #creating a matrix by binding rows, using rbind()

Example 2
mat1 <- matrix(1:20, nrow=5,ncol=4) #making a vector into a matrix with 5 rows and 4 columns
summary(mat1)
c(mat1) #putting matrix back into vector

mat2 <- matrix(20:1, nrow=5, ncol = 4, byrow=T) # if byrow=T option fills the matrix by rows, default is by columns

nrow(mat1) #number of rows
ncol(mat1) #number of columns 
dim(mat1) #dimensions of mat shown in number of rows and number of columns
length(mat1) #length of mat (notice difference!), number of items in matrix

##############################Indexing a matrix###############################
#matrix[row, column]
mat1[3, 1] #####looking for 3rd row, 1st column entry
mat1[1:3, 1:2] ###looing for elements in rows 1:3 and columns 1:2

mat1+mat2
mat1-mat2
mat1/mat2
mat1*mat2
mat1^mat2

mat1<mat2
mat1<=mat2
mat1>mat1
mat1>=mat2
mat1==mat2
mat1!=mat2

sum(mat1) ###sum of whole matrix 
mean(mat1)
colSums(mat1) ###sum of columns
rowSums(mat1) ###sum of rows
colMeans(mat1)
rowMeans(mat1)

######which command with matrices

which(mat1>3) ####gives answer in vector index!!
which(mat1>3, arr.ind=T) #####gives row col index which command

match(mat1, mat2) ########gives answer in vector index!
mat1 %in% mat2 ####gives answer in vector index!

colnames(mat1) <- c("lon", "lat", "time", "value")

################### save, write/read with various file types ##############

setwd() # set working directory 
getwd() # get working directory  

########### Rdata 
getwd() #this is the directory you are currently working in
setwd("/User/Desktop/R_files") # change to where you would like a file to be saved 
save(mat1, file="mat1.Rdata") #save matrix

load("mat1.Rdata") # load matrix

######### CSV file 
dat<-read.csv("means.csv")
write.csv(mat1, file="mat1.csv")

######### txt file 
dat<-read.table("means.txt")
write.table(dat2, file="dat2.txt")

######### excel file 
require(gdata)
data1<-read.xls("data.xls")

########## .dat file
lat <- readBin("v2.dat", what="integer", size=4, n=(332*316), signed=T)

########## .nc or NCDF file 
f <- nc_open("A20021852011273.L3m_CU_CHL_chlor_a_9km.nc")
chl <- ncvar_get(f, "l3m_data")
nc_close(f)

########## matlab files 
require(hdf5)
mat<-hdf5load(“data.mat”, load=FALSE)
OR
require(R.matlab)
r <- readMat("data.mat", verbose=T)



############## plotting ##########################
plot(1:10, 1:10, pch=20)
plot(1:10, 1:10, pch=20, type="o")
points(jitter(1:10), jitter(1:10), pch=21, cex=2, col="blue")

hist(a2) #histogram 

#other plots: barplot(), scatterplot3d()

############ MERGE DATA example ############################
all_years<-as.data.frame(c(1974:2013))
colnames(all_years)<-"yr"

#load data using scan() function 
number_fish<-scan()
1   8   0   1  12   0   1   NA   1  11 102   0   8   5   2   0   2   NA

fish_weight<-scan ()
412 NA 384 450 259 389 339 350 297 320 261 285 267 NA 200 204 194 143

#make matrix of time series 
fish<-cbind(1991:2008, number_fish, fish_weight)
colnames(fish)<-c("yrs", "no_fish", "fish_kg")

#we want to merge all years and our fish matrix 
diet<-merge(all_years, fish, by.x="yr", by.y= "yrs",all = TRUE)

##############other commands

#subset- useful if you only want to look at a some of the data in a matrix 
#example: look at years where the number of fish was greater than 0
subset(fish, fish[,1]>0) 

#replace a value with something else
replace(fish, fish==NA, 0)

#remove year 1995 by deleting that row 
fish[-5,]

round(x,n)                                #rounds the values of x to n decimal places(ceiling(x)                                #vector x of smallest integers > x(floor(x)                                  #vector x of largest integer < x(
rev(x)      #reverse the order of values in x(
cor(x,y,use="pair") #parwise correlation between x and y 
t.test(x,y) 


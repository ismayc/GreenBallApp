gbSim <- function(numReps, numDraws){
  #Declare matrix with size (Number of Draws + 1 by 1)
  #numDraws + 1 to include P(X = 0)
  gbFreq <- matrix(0, numDraws + 1, 1)
  
  #Initialize the number of Green Balls to 0
  nGB <- 0
  
  #Initialize numBalls to 5 (1G, 4W)
  numBalls <- 5
  
  #Walk through the outer loop numReps times
  seqTime <- system.time({
    for(i in 1:numReps){ #foreach(i = 1:numReps) %do% { 
      nGB <- 0 #For each draw, initialize to 0 nGB
      hopper <- 1:numBalls #For each draw, initialize the ball set
      
      #Walk through inner loop for each draw
      for(j in 1:numDraws){ #foreach(j = 1:numDraws) %do% { 
        #If all balls have been drawn reset to (1G, remaining W)
        if(length(hopper) == 0)
          hopper <- 1:numBalls
        
        #Draw a ball without replacement from the hopper
        drawnBall <- sample(hopper, size = 1)
        
        #Let 1 correspond to green ball
        if(drawnBall == 1){
          nGB <- nGB + 1 #If GB, increment nGB
          hopper <- 1:numBalls #Reset the ball set
        }
        
        #If white ball, remove that white ball from the hopper
        else hopper <- setdiff(hopper, drawnBall)
      }
      
      #Update frequency corresponding to how many times a GB was chosen in the numDraws
      #Since nGB is initialized to 0 we add 1 to the index
      gbFreq[nGB + 1] <- gbFreq[nGB + 1] + 1
    }
  })[3]
  #print(seqTime)
  #print(sum(gbFreq)) #Check that frequencies add up
  gbProb <- gbFreq/numReps #Display approximate distribution of X
  #print("Simulated Distribution of X")
  #print(gbProb)
  #print(\n)
  
  #simMean <- 0
  # for(i in 1:length(gbFreq)) 
  #  simMean <- simMean + (i-1) * gbProb[i]
  
  #print("Simulated Mean of X")
  #print(simMean)
}

for(i in 1:500)
{
  write(gbSim(10000, i), "gb500x10K.txt", ncolumns=501, append=TRUE)
  print(i)
}



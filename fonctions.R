

##############################################################
## Fonction qui retourne une matrice carr�e donn�e en entr�e ##
##############################################################

## La fonction prend en entr�e une matrice carr�e sous format csv (il faut indiquer le chemin)
## La fonction cr�e la matrice sous R



matrice <- function(fichier)
{ 
  donnees<-read.table(fichier,sep=";")
  A <- as.matrix (donnees)
  return (A)
}

 
##############################################################
## Fonction qui inverse une matrice carr�e donn�e en entr�e ##
##############################################################

## La fonction prend en entr�e une matrice carr�e 
## La fonction cr�e la matrice inverse de cette matrice 



inverse <- function(mat)
{ 
  return (solve(mat))
}



###################################################################################
## Fonction qui retourne I-A (I+A pour la 2) pour une matrice A carr�e en entr�e ##
###################################################################################

## La fonction prend en entr�e une matrice carr�e.
## La fonction cr�e la matrice identit� moins la matrice en entr�e.


identite <- function(A)
{
  rang <- nrow(A)
  I <- diag(nrow = rang)
  return (I-A) 
}




####################################################
## Fonction de calcul des coefficients techniques ##
####################################################

## La fonction prend en entr�e :
    ## - un TEI domestique ou import� (A) sous forme de matrice carr�e  
    ## - la production ou vecteur des importations totale de chaque branche (B) sous forme de vecteur
## La fonction cr�e la matrice des coefficients techniques domestiques ou import�s. 


  coef_techniques <- function (A,B)
  {
    tei <- A
    prod <- B
    ctec <- matrix(nrow = nrow(tei), ncol = ncol(tei))
    if (ncol(tei) == length(prod)) {
      for (i in 1:nrow(tei)) {
        for (j in 1:ncol(tei)) {
          if (prod[j]==0) {
            ctec[i,j] <- 0
          }else{
            ctec[i,j] <- tei[i,j]/prod[j]
          }
        }
      }
      return (ctec)
    }else {
      cat("Erreur : la taille du vecteur de production et du TEI ne sont pas coh�rentes")
    }
  }

coef_debouches <- function (A,B)
{
  tei <- A
  prod <- B
  ctec <- matrix(nrow = nrow(tei), ncol = ncol(tei))
  if (ncol(tei) == length(prod)) {
    for (i in 1:nrow(tei)) {
      for (j in 1:ncol(tei)) {
        if (prod[i]==0) {
          ctec[i,j] <- 0
        }else{
          ctec[i,j] <- tei[i,j]/prod[i]
        }
      }
    }
    return (t(ctec))
  }else {
    cat("Erreur : la taille du vecteur de production et du TEI ne sont pas coh�rentes")
  }
}

############################################
## Calcul des effets directs et indirects ##
############################################

## Les fonctions prennent en entr�e la matrice des coefficients techniques et retournent les
## multiplicateurs directs et indirects

direct <- function(A)
{
  rang <- nrow(A)
  I <- diag(nrow = rang)
  return (I+A) 
}

indirect <- function(A)
{
  rang <- nrow(A)
  I <- diag(nrow = rang)
  I_A <- identite(A=A)
  inv_I_A <- inverse(mat=I_A)
  return (inv_I_A-I-A) 
}

indirect_imp <- function(A,B) {
  rang <- nrow(A)
  I <- diag(nrow = rang)
  I_A <- identite(A=A)
  inv_I_A <- inverse(mat=I_A)
  return (B %*% inv_I_A-B)
}
  
####################################################
## Cr�ation indices de prix et recalcul de valeur ##
####################################################

indice_prix <- function(valeur, volume)
{
  ind_prix <- matrix(nrow = nrow(valeur), ncol = ncol(valeur))
  if (ncol(valeur) == ncol(volume) & nrow(valeur) == nrow(volume)) {
    for (i in 1:nrow(valeur)) {
      for (j in 1:ncol(valeur)) { 
        if (volume[i,j]==0) {
          ind_prix[i,j] <- 0
        } else {
          ind_prix[i,j] <- valeur[i,j]/volume[i,j] 
        }
      }
    }
  } else {
    cat("Erreur : les tailles des matrices volume et valeur ne sont pas identiques")
  }
  return (ind_prix)
}


valeur <- function(prix, volume)
{
  valeur <- matrix(nrow = nrow(prix), ncol = ncol(prix))
  if (ncol(prix) == ncol(volume) & nrow(prix) == nrow(volume)) {
    for (i in 1:nrow(prix)) {
      for (j in 1:ncol(prix)) { 
        valeur[i,j] <- prix[i,j]*volume[i,j] 
      }
    }
  } else {
    cat("Erreur : les tailles des matrices volume et valeur ne sont pas identiques")
  }
  return (valeur)
}







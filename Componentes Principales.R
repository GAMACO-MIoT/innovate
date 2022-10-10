#install.packages("RODBC")
#install.packages("MicrosoftML")

#install.packages("RevoScaleR")
#library(RevoScaleR)

# install.packages("MASS")
{
  library(RODBC)
  library(ggplot2)
  library(dplyr)
  library(DataEditR)
  #  library (outliers)
  library(mclust)
  library(ggplot2)
  library(ggvis)
  #  library(car)
  library(GGally)
  library(rpart)
  library(rpart.plot)
  library(caret)  
  library(devtools) 
  library(googleVis)
  library(tidyr)
  library(MASS)
  library(ggthemes)
  
  library(plotly)
  
}

{ 
  
  DBCHEC <-   odbcDriverConnect('driver={SQL Server};
                            server=JUAN_MARIN;
                            database=master;
                            trusted_connection=true')
  
  Fact_ordenes_trabajo_GIIP <-   sqlQuery(DBCHEC, 'SELECT [IDE_ORDEN_TRABAJO]
,[NUMERO_TPL_EN_GIIP]
,[HORA_DESPLAZAMIENTO]
,[HORA_LLEGADA]
,[FIN_EJECUCION]
,[HORA_ENERGIZACION]
,[HORA_CIERRE]
,[CODIGO_ORDEN_JDE]
,[USR_DIGITO]
,[DESCRIPCION_1]
,[DESCRIPCION_2]
,[DESCRIPCION_3]
,[DESCRIPCION_4]
,[DESCRIPCION_5]
,[OBSERVACIONES]
,[FEC_CREACION]
,[CODIGO_TRABAJO_CONTRATO]
,[ZONA]
,[CIRCUITO]
,[NUM_SOLICITUD]
,[TRABAJO]
,[ORDEN_ORIGINAL]
,[ID_CONTRATO]
,[FECHA_CIERRE]
,[NODO_TRAMO]
,[PROCEDENCIA]
,[CODIGO_REPARACION]
,[CODIGO_ORDEN_JDE1]
,[DESCRIPCION_ORDEN_JDE]
,[CUADRILLA]
,[TIPO_DE_CUADRILLA]
,[SALIDA_CUADRILLA_INICIODESPLAZ]
,[ANNO_DESPLAZAMIENTO]
,[ESTADO]
,[ID_MATERIAL]
,[CANTIDAD]
,[ID_NODO_SEC]
,[ID_TRABAJO_CONTRATO]
,[CODIGO_OW]
,[DESCRIPCION]
,[BODEGA_OW]
,[DESCRIPCION_BODEGA]
,[VALOR_MATERIAL]
FROM [CHEC].[dbo].[Fact_ordenes_trabajo_GIIP]')
}





#library(caret)
{set.seed(880320)
  
  trainIndex=createDataPartition(Fact_ordenes_trabajo_GIIP$IDE_ORDEN_TRABAJO, p=0.8)$Resample1
  
  train = Fact_ordenes_trabajo_GIIP[-trainIndex, ]
  
summary(train)
  #select: seleccionar un subconjunto
  
  DB1 <- dplyr::select(train, c(HORA_DESPLAZAMIENTO, HORA_LLEGADA, 
                                FIN_EJECUCION, HORA_ENERGIZACION, 
                                ZONA, CIRCUITO, NODO_TRAMO,
                                PROCEDENCIA, CUADRILLA))
  
  
  Clean1 <- gsub("(.)\\.?[Mm]\\.?","\\1m", DB1$HORA_DESPLAZAMIENTO)
  T1 <- as.POSIXct(Clean1, format="%d/%m/%Y %I:%M:%S %p", tz="UTC")
  
  
  Clean2 <- gsub("(.)\\.?[Mm]\\.?","\\1m", DB1$HORA_LLEGADA)
  T2 <- as.POSIXct(Clean2, format="%d/%m/%Y %I:%M:%S %p", tz="UTC")
  
  Clean3 <- gsub("(.)\\.?[Mm]\\.?","\\1m", DB1$FIN_EJECUCION)
  T3 <- as.POSIXct(Clean3, format="%d/%m/%Y %I:%M:%S %p", tz="UTC")
  
  
  Clean4 <- gsub("(.)\\.?[Mm]\\.?","\\1m", DB1$HORA_ENERGIZACION)
  T4 <- as.POSIXct(Clean4, format="%d/%m/%Y %I:%M:%S %p", tz="UTC")
  
  
  DIF1 <- difftime(T2, T1, units="mins")
  DIF1 = round(as.numeric(DIF1))
  
  DIF2 <- difftime(T3, T2, units="mins")
  DIF2 = round(as.numeric(DIF2))
  
  DIF3 <- difftime(T4, T3, units="mins")
  DIF3 = round(as.numeric(DIF3))
  
  
  DIF4 <- difftime(T4, T1, units="mins")
  DIF4 = round(as.numeric(DIF4))
  
  
  MES <- as.numeric(format(T1,'%m'))
  
  DB10 <- cbind(DB1, MES, DIF1, DIF2, DIF3, DIF4)
  
  DB10 <-filter(DB10, DB10$DIF4 >0, DB10$DIF4 <600, DB10$DIF1>0, DB10$DIF2 >0, DB10$DIF3 >0)
     
  DB11 <- dplyr::select(DB10, -c(HORA_DESPLAZAMIENTO, HORA_LLEGADA, 
                                 FIN_EJECUCION, HORA_ENERGIZACION))
  
  #Para convertir varias variables a factor
  #Las guardamos en un vector
  cols<- c("ZONA", "CIRCUITO", "NODO_TRAMO", "PROCEDENCIA", "CUADRILLA")
  #Le aplicamos una misma función a todas las columnas con lapply  
  DB11[cols] <- lapply(DB11[cols], factor)
  
  
  DB11 = na.omit(DB11)
  
}
summary(DB11)


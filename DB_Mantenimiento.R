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
DBCHEC <-   odbcDriverConnect('driver={SQL Server};
                            server=JUAN_MARIN;
                            database=master;
                            trusted_connection=true')
{

Fact_mantenimiento <-   sqlQuery(DBCHEC, 'SELECT [id_fact_mantenimiento]
      ,[sk_id_tipo_causa]
      ,[id_subregion]
      ,[sk_feeders]
      ,[sk_id_tipo_elemento]
      ,[sk_id_elemento]
      ,[id_periodo]
      ,[id_grupo_calidad]
      ,[id_region]
      ,[sk_id_causa]
      ,[sk_nodo]
      ,[sk_feeders_origen]
      ,[descri_elemento]
      ,[ODO]
      ,[nivel]
      ,[evento]
      ,[Duracion]
      ,[Inicio]
      ,[Fin]
      ,[consumos]
      ,[usuarios]
  FROM [CHEC].[dbo].[Fact_mantenimiento]')
}
  
  
  trainIndex=createDataPartition(Fact_mantenimiento$id_fact_mantenimiento, p=0.8)$Resample1
  train = Fact_mantenimiento[-trainIndex, ]
  
  summary(train)  
  
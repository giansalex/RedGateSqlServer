SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Doc_ContratoDetAlerta]
@RucE Nvarchar(11),
@msj varchar(100) output
as
declare @today datetime
set @today = GETDATE()


--Select FecDef,DATEDIFF(DAY,@today,FecDef) as dia from ContratoDet where RucE='11111111111'
--set @dif = (Select DATEDIFF(DAY,GETDATE(),FecDef) as dia from ContratoDet where RucE=@Ruc and Cd_Ctt='10' and Item=1)

select SUM(NumAlertas) NumAlertas from (
select COUNT(*) as NumAlertas from ContratoDet where
RucE=@RucE 
group by FecDef  
having(DATEDIFF(DAY,GETDATE(),FecDef) BETWEEN 0 AND 5)
) as cons

GO

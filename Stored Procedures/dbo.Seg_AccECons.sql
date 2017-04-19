SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Seg_AccECons] --Consulta EmpXPerfil
@Cd_Prf nvarchar(3)
as
select distinct Ruc, RSocial, Cd_MdaP 
from AccesoE a, Empresa b, GrupoAcceso c 
where Cd_Prf=@Cd_Prf and RucE=Ruc and a.Cd_GA=c.Cd_GA and c.Estado=1 
order by RSocial


--PV  --> Lun10/11/08 Creado
--PV  --> Mar15/12/09 Mdf: se agrego para que se tome en cuenta el estado de GrupoAcceso a la hora de consultar las empresas
--MP : 16/05/2010 : <Modificacion del procedimiento almacenado>
GO

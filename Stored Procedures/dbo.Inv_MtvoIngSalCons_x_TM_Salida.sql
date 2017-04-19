SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalCons_x_TM_Salida]
@RucE nvarchar(11),
@Cd_TM char(2),
@msj varchar(100) output
as

set @msj = 'No se usa este Store Procedure. Puede ser borrado.'
/*
select Cd_MIS+'  |  '+Descrip as CodNom,Cd_MIS,Descrip, convert( bit, case(IC_ES) when 'E' then  '1' else '0' end) as EsEntrada  
from MtvoIngSal Where RucE=@RucE and Estado=1 and Cd_TM = @Cd_TM
and IC_ES = 'S'
*/
print @msj
------------
--CAM : 25/02/2011 <Creacion del procedimiento almacenado>
-- exec Inv_MtvoIngSalCons_x_TM_Salida '11111111111','05',''
GO

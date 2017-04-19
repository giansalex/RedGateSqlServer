SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalCons_x_TM]
@RucE nvarchar(11),
@Cd_TM char(2),
@msj varchar(100) output
as
		select Cd_MIS+'  |  '+Descrip as CodNom,Cd_MIS,Descrip, convert( bit, case(IC_Tipo) when 'E' then  '1' else '0' end) as EsEntrada  from MtvoIngSal Where RucE=@RucE and Estado=1 and Cd_TM = @Cd_TM

print @msj
------------
--PP : 2010-08-11 21:45:59.920	<Creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MtvoIngSalCons_x_TM_ES]
@RucE nvarchar(11),
@Cd_TM char(2),
@IC_Tipo char(1),
@msj varchar(100) output
as
		select Cd_MIS+'  |  '+Descrip as CodNom,Cd_MIS,Descrip, convert( bit, case(IC_Tipo) when 'E' then  '1' else '0' end)  from MtvoIngSal Where RucE=@RucE and Estado=1 and Cd_TM = @Cd_TM and IC_Tipo=@IC_Tipo

print @msj
------------
--PV : 2010-12-16  creado
GO

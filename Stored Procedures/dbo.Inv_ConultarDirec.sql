SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ConultarDirec]
@RucE nvarchar(11),
@Cd_Vta nvarchar(20),
@msj varchar(100) output,
@RSocial varchar(150) output,
@ApPat varchar(20) output,
@ApMat varchar(20) output,
@Nom varchar(20) output
as
begin
select c.Cd_Clt,c.RSocial,c.ApPat,c.ApMat,c.Nom from Cliente2 c
inner join Venta v on c.Cd_Clt=v.Cd_Clt and v.Cd_Vta=@Cd_Vta
where c.RucE=@RucE and v.Cd_Vta=@Cd_Vta
end
print @msj
print @RSocial
print @ApPat
print @Nom
------------
--FL : 26-10-2010 - <Creacion del procedimiento almacenado>
GO

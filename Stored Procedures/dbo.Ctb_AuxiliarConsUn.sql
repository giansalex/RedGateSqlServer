SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AuxiliarConsUn]
@RucE nvarchar(11),
@Cd_Aux nvarchar(7),
@msj varchar(100) output
as
if not exists (select * from Auxiliar where RucE=@RucE and Cd_Aux=@Cd_Aux)
	set @msj = 'Auxiliar no existe'
else	
begin
	select a.*,c.Cta as CtaCli, p.Cta as CtaPro
	from Auxiliar a
	left join Cliente c on c.RucE=a.RucE and c.Cd_Aux=a.Cd_Aux
	left join Proveedor p on p.RucE=a.RucE and p.Cd_Aux=a.Cd_Aux
	where a.RucE=@RucE and a.Cd_Aux=@Cd_Aux
end
print @msj
-- DI 05/03/2009 MODIFICACIONES : Enviar los campos de CtaCli y CtaPro
GO

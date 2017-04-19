SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_BancoCrea]
--@Itm_BC nvarchar(10),
@RucE nvarchar(11),
@NroCta nvarchar(10),
@NCtaB nvarchar(50),
@NCorto varchar(6),
@Cd_Mda varchar(2),
--@Estado bit,
@msj varchar(100) output
as
set @msj = 'Banco no pudo ser registrado, debe de actualizar el sistema'
/*--select Cd_BC,Nombre,NCorto,NCta,Cd_Mda,Estado from Banco
if exists (select * from Banco where RucE=@RucE and NroCta=@NroCta)
	set @msj = 'Banco ya existe'
else
begin
	insert into Banco(Itm_BC,RucE,NroCta,NCtaB,NCorto,Cd_Mda,Estado)
	values(user123.Itm_BC(@RucE),@RucE,@NroCta,@NCtaB,@NCorto,@Cd_Mda,1)

	if @@rowcount <= 0
	   set @msj = 'Banco no pudo ser registrado'
end*/
print @msj
GO

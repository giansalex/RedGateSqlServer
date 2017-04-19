SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_BancoCrea2]
--@Itm_BC nvarchar(10),
@RucE nvarchar(11),
@NroCta nvarchar(10),
@NCtaB nvarchar(50),
@NCorto varchar(6),
@Cd_Mda varchar(2),
--@Estado bit,
@Ejer varchar(4),
@Cd_EF char(2),
@msj varchar(100) output
as
--select Cd_BC,Nombre,NCorto,NCta,Cd_Mda,Estado from Banco
if exists (select * from Banco where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)
	set @msj = 'Banco ya existe'
else
begin
	insert into Banco(Itm_BC,RucE,NroCta,NCtaB,NCorto,Cd_Mda,Estado,Ejer,Cd_EF)
	values(user123.Itm_BC(@RucE),@RucE,@NroCta,@NCtaB,@NCorto,@Cd_Mda,1,@Ejer,@Cd_EF)

	if @@rowcount <= 0
	   set @msj = 'Banco no pudo ser registrado'
end
print @msj



GO

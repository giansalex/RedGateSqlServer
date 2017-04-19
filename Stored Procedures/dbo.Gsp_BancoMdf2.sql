SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_BancoMdf2]
@Itm_BC nvarchar(10),
@RucE nvarchar(11),
@NroCta nvarchar(10),
@NCtaB nvarchar(50),
@NCorto varchar(6),
@Cd_Mda varchar(2),
@Estado bit,
@Ejer varchar(4),
@Cd_EF char(2),
@msj varchar(100) output
as

if not exists (select * from Banco where RucE=@RucE and Ejer=@Ejer and Itm_BC=@Itm_BC)
	set @msj = 'Banco no existe'
else
begin
	update Banco set NroCta=@NroCta, NCtaB=@NCtaB, NCorto=@NCorto, Cd_Mda=@Cd_Mda, Estado=@Estado, Cd_EF=@Cd_EF
	where RucE=@RucE and Ejer= @Ejer and Itm_BC=@Itm_BC

	if @@rowcount <= 0
	   set @msj = 'Banco no pudo ser modificado'
end
print @msj



GO

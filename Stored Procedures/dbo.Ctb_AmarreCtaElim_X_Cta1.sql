SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Ctb_AmarreCtaElim_X_Cta1]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@Ejer varchar(4),
@msj varchar(100) output
as
begin
	delete from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta 

	if @@rowcount <= 0
		set @msj = 'No se elimino ningun amarre'
end

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR AL FINAL ****

CREATE procedure [pvo].[Ctb_VoucherCreaDest]
@RucE nvarchar(11),
@NroCta	nvarchar(10),
@msj varchar(100) output
--with encryption
AS

declare @CtaD nvarchar(10), @CtaH nvarchar(10), @Porc numeric(5,2)

declare Cur_CtaDet cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and NroCta=@NroCta
open Cur_CtaDet	
     fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
	-- mientras haya datos
	while (@@fetch_status=0)
	begin
		print @CtaD
		print @CtaD
		print @Porc
	

	fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
	END
close Cur_CtaDet
deallocate Cur_CtaDet

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR ACA ****

GO

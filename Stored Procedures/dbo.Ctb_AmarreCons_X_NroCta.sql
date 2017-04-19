SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCons_X_NroCta]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@msj varchar(100) output
as
/*if not exists (select * from AmarreCta where RucE=@RucE and NroCta=@NroCta)
	set @msj = 'No se encontro ningun amarre con ese numero de cuenta'
else*/	select ItmA,CtaD as Debe,CtaH as Haber,Porc from AmarreCta where RucE=@RucE and NroCta=@NroCta
GO

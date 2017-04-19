SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AmarreCons_X_NroCta1]
@RucE nvarchar(11),
@NroCta nvarchar(10),
@Ejer varchar(4),
@msj varchar(100) output
as
/*if not exists (select * from AmarreCta where RucE=@RucE and NroCta=@NroCta)
	set @msj = 'No se encontro ningun amarre con ese numero de cuenta'
else*/	select /*top 2*/ Item as ItmA,CtaD as Debe,CtaH as Haber,Porc from AmarreCta where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer

--MP : 23/10/2011 : <Creacion del procedimiento almacenado>


--Pruebas
/*
exec Ctb_AmarreCons_X_NroCta1 '20160000001','63.4.3.10','2016',null
select * from AmarreCta where RucE='20160000001' and Ejer='2016' and NroCta='63.4.3.10'

*/
GO

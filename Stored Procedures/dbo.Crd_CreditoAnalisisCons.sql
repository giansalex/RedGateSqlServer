SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Crd_CreditoAnalisisCons]

@RucE nvarchar(11),
@FecDesde datetime,
@FecHasta datetime,

@Colum varchar(100),
@Dato varchar(100),



@msj varchar(100) output

AS
	declare @Tablas varchar(3000)
	declare @Cond varchar(2000)
	declare @Consulta  varchar(8000)

	Set @Tablas =' CreditoAnalisis a
		Left Join Cliente2 c On c.RucE=a.RucE and c.Cd_Clt=a.Cd_Clt
		'
		
	set @Cond = ' a.RucE='''+@RucE+''' and a.FecMov >=Convert(datetime,'''+Convert(varchar,@FecDesde,103)+''') and a.FecMov<=Convert(datetime,'''+Convert(varchar,@FecHasta,103)+'''+'' 23:59:59'') '
	
	if(@Colum = 'FecMov')  set @Cond = @Cond+ ' and Convert(varchar,a.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'NroDocClt')  set @Cond = @Cond+ ' and c.NDoc  like '''+@Dato+''''
	else if(@Colum = 'NomClt')  set @Cond = @Cond+ ' and isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,''''))  like '''+@Dato+''''
	else if(@Colum = 'TipoVivienda')  set @Cond = @Cond+ ' and a.TipoVivienda  like '''+@Dato+''''
	else if(@Colum = 'EstCivil')  set @Cond = @Cond+ ' and a.EstCivil  like '''+@Dato+''''
	else if(@Colum = 'CantFam')  set @Cond = @Cond+ ' and a.CantFam  like '''+@Dato+''''
	else if(@Colum = 'CantHijos')  set @Cond = @Cond+ ' and a.CantHijos  like '''+@Dato+''''
	else if(@Colum = 'Sexo')  set @Cond = @Cond+ ' and a.Sexo  like '''+@Dato+''''
	else if(@Colum = 'Ren01')  set @Cond = @Cond+ ' and a.Ren01  like '''+@Dato+''''
	else if(@Colum = 'Ren02')  set @Cond = @Cond+ ' and a.Ren02  like '''+@Dato+''''
	else if(@Colum = 'Ren03')  set @Cond = @Cond+ ' and a.Ren03  like '''+@Dato+''''
	else if(@Colum = 'Ren04')  set @Cond = @Cond+ ' and a.Ren04  like '''+@Dato+''''
	else if(@Colum = 'Ren05')  set @Cond = @Cond+ ' and a.Ren05  like '''+@Dato+''''
	else if(@Colum = 'OtrosIng')  set @Cond = @Cond+ ' and a.OtrosIng like '''+@Dato+''''
	else if(@Colum = 'TotalIng')  set @Cond = @Cond+ ' and a.TotalIng like '''+@Dato+''''
	else if(@Colum = 'CanastaFam')  set @Cond = @Cond+ ' and a.CanastaFam like '''+@Dato+''''
	else if(@Colum = 'Vivienda')  set @Cond = @Cond+ ' and a.Vivienda like '''+@Dato+''''
	else if(@Colum = 'Colegio')  set @Cond = @Cond+ ' and a.Colegio like '''+@Dato+''''
	else if(@Colum = 'PrestamoBan')  set @Cond = @Cond+ ' and a.PrestamoBan like '''+@Dato+''''
	else if(@Colum = 'CreditoBan')  set @Cond = @Cond+ ' and a.CreditoBan like '''+@Dato+''''
	else if(@Colum = 'OtrosEgr1')  set @Cond = @Cond+ ' and a.OtrosEgr1 like '''+@Dato+''''
	else if(@Colum = 'OtrosEgr2')  set @Cond = @Cond+ ' and a.OtrosEgr2 like '''+@Dato+''''
	else if(@Colum = 'TotalEgr')  set @Cond = @Cond+ ' and a.TotalEgr like '''+@Dato+''''
	else if(@Colum = 'SaldoDisp')  set @Cond = @Cond+ ' and a.SaldoDisp like '''+@Dato+''''
	else if(@Colum = 'PorcDisp')  set @Cond = @Cond+ ' and a.PorcDisp like '''+@Dato+''''
	else if(@Colum = 'ImpDisp')  set @Cond = @Cond+ ' and a.ImpDisp like '''+@Dato+''''
	else if(@Colum = 'ValorCrd')  set @Cond = @Cond+ ' and a.ValorCrd like '''+@Dato+''''
	else if(@Colum = 'TasaAnu')  set @Cond = @Cond+ ' and a.TasaAnu like '''+@Dato+''''
	else if(@Colum = 'ValorTasa')  set @Cond = @Cond+ ' and a.ValorTasa like '''+@Dato+''''
	else if(@Colum = 'TotalCrd')  set @Cond = @Cond+ ' and a.TotalCrd like '''+@Dato+''''
	else if(@Colum = 'NroCuotas')  set @Cond = @Cond+ ' and a.NroCuotas like '''+@Dato+''''
	else if(@Colum = 'CuotaMen')  set @Cond = @Cond+ ' and a.CuotaMen like '''+@Dato+''''
	else if(@Colum = 'CA01')  set @Cond = @Cond+ ' and a.CA01 like '''+@Dato+''''
	else if(@Colum = 'CA02')  set @Cond = @Cond+ ' and a.CA02 like '''+@Dato+''''
	else if(@Colum = 'CA03')  set @Cond = @Cond+ ' and a.CA03 like '''+@Dato+''''
	else if(@Colum = 'CA04')  set @Cond = @Cond+ ' and a.CA04 like '''+@Dato+''''
	else if(@Colum = 'CA05')  set @Cond = @Cond+ ' and a.CA05 like '''+@Dato+''''
	else if(@Colum = 'CA06')  set @Cond = @Cond+ ' and a.CA06 like '''+@Dato+''''
	else if(@Colum = 'CA07')  set @Cond = @Cond+ ' and a.CA07 like '''+@Dato+''''
	else if(@Colum = 'CA08')  set @Cond = @Cond+ ' and a.CA08 like '''+@Dato+''''
	else if(@Colum = 'CA09')  set @Cond = @Cond+ ' and a.CA09 like '''+@Dato+''''
	else if(@Colum = 'CA10')  set @Cond = @Cond+ ' and a.CA10 like '''+@Dato+''''
	else if(@Colum = 'CA11')  set @Cond = @Cond+ ' and a.CA11 like '''+@Dato+''''
	else if(@Colum = 'CA12')  set @Cond = @Cond+ ' and a.CA12 like '''+@Dato+''''
	else if(@Colum = 'CA13')  set @Cond = @Cond+ ' and a.CA13 like '''+@Dato+''''
	else if(@Colum = 'CA14')  set @Cond = @Cond+ ' and a.CA14 like '''+@Dato+''''
	else if(@Colum = 'CA15')  set @Cond = @Cond+ ' and a.CA15 like '''+@Dato+''''
	else if(@Colum = 'CA16')  set @Cond = @Cond+ ' and a.CA16 like '''+@Dato+''''
	else if(@Colum = 'CA17')  set @Cond = @Cond+ ' and a.CA17 like '''+@Dato+''''
	else if(@Colum = 'CA18')  set @Cond = @Cond+ ' and a.CA18 like '''+@Dato+''''
	else if(@Colum = 'CA19')  set @Cond = @Cond+ ' and a.CA19 like '''+@Dato+''''
	else if(@Colum = 'CA20')  set @Cond = @Cond+ ' and a.CA20 like '''+@Dato+''''
	
Set @Consulta=		
	'
	Select 
		a.Cd_ACrd,
		a.FecMov,
		
		c.NDoc As NroDocClt,
		isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) As NomClt,
		
		a.TipoVivienda,
		a.EstCivil,
		a.CantFam,
		a.CantHijos,
		a.Sexo,
		a.Ren01,
		a.Ren02,
		a.Ren03,
		a.Ren04,
		a.Ren05,
		a.OtrosIng,
		a.TotalIng,
		a.CanastaFam,
		a.Vivienda,
		a.Colegio,
		a.PrestamoBan,
		a.CreditoBan,
		a.OtrosEgr1,
		a.OtrosEgr2,
		a.TotalEgr,
		a.SaldoDisp,
		a.PorcDisp,
		a.ImpDisp,
		a.ValorCrd,
		a.TasaAnu,
		a.ValorTasa,
		a.TotalCrd,
		a.NroCuotas,
		a.CuotaMen,
		a.CA01,	a.CA02,	a.CA03,	a.CA04,a.CA05,	a.CA06,	a.CA07,	a.CA08,		a.CA09,		a.CA10,		a.CA11,
		a.CA12,		a.CA13,		a.CA14,		a.CA15,		a.CA16,		a.CA17,		a.CA18,		a.CA19,		a.CA20
	'
	
	Print @Consulta
	Print 'from '+@Tablas
	Print 'where '+@Cond
	Print 'order by 1,2'
	
	Exec (@Consulta + '
			from '+@Tablas+'
			where '+@Cond+'
			order by 1,2'
		 )

-- leyenda --
-- DI : 24/11/2011 <Creacion del SP>
		 
GO

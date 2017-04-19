SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2_explo_PagAnt1]--<Mantenimiento de Producto2>
@RucE nvarchar(11),
@TamPag int,
@Ult_Prod nvarchar(7),
@Max nvarchar(7) output,
@Min nvarchar(7) output,
@TipProd int=3,
@msj varchar(100) output
as

	/*	declare @RucE nvarchar(11)
		declare @TamPag int
		declare @Max nvarchar(10)
		declare @Min nvarchar(10)
		declare @Ult_Aux nvarchar(10)
		set @TamPag = 5
		set @RucE = '11111111111'
		set @Max = 'VND0004'
		set @Min = 'AUX0001'
		set @Ult_Aux='VND0004'
		*/
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> consulta productos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @Inter varchar(1000)
	set @Inter = 'Producto2 a'
	declare @sql nvarchar(4000)
	declare @Cond varchar(1000)
	if(@TipProd=0)--para PT
		set @Cond = ' a.IB_PT=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod<'''+isnull(@Ult_Prod,'')+''''
	else if(@TipProd=1)--para MP
		set @Cond = ' a.IB_MP=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod<'''+isnull(@Ult_Prod,'')+''''
	else if(@TipProd=2)--para EE
		set @Cond = ' a.IB_EE=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod<'''+isnull(@Ult_Prod,'')+''''
	else if(@TipProd=3)--para TODO
		set @Cond = ' a.RucE= '''+@RucE+'''and a.Cd_Prod<'''+isnull(@Ult_Prod,'')+''''
	else if(@TipProd=4)--para PV
		set @Cond = ' a.IB_PV=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod<'''+isnull(@Ult_Prod,'')+''''
	else if(@TipProd=5)--para PC
		set @Cond = ' a.IB_PC=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod<'''+isnull(@Ult_Prod,'')+''''
	else if(@TipProd=6)--para ActFijo
		set @Cond = ' a.IB_AF=1 and a.RucE= '''+@RucE+'''and a.Cd_Prod<'''+isnull(@Ult_Prod,'')+''''
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select distinct *from (select top '+Convert(nvarchar,@TamPag)+' a.RucE,a.Cd_Prod,a.Nombre1,a.Nombre2,a.NCorto,a.Descrip,a.Cta1,a.Cta2,a.Cta3,a.Cta4,a.Cta5,a.Cta6,a.Cta7,a.Cta8,a.CodCo1_,a.CodCo2_,a.CodCo3_,
	a.CodBarras,a.FecCaducidad,
	a.StockMin,a.StockMax,a.StockAlerta,a.StockActual,a.StockCot,a.StockSol,
	t.CodSNT_ as Cd_TE,
	--a.Cd_TE,
	a.Cd_Mca,a.Cd_CL,a.Cd_CLS,a.Cd_CLSS, 
	a.Cd_CGP,Cd_CC,Cd_SC,Cd_SS,a.UsuCrea,a.UsuMdf,a.FecReg,a.FecMdf,a.Estado,a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10,a.IB_Srs,
	convert(int,case(c.Cd_ProdB) when a.Cd_Prod then ''1'' else ''0'' end) as EsGrupo from 
	'+@Inter+' 
	 left join ProdCombo c on a.RucE=c.RucE and a.Cd_Prod=c.Cd_ProdB
	 left join TipoExistencia t on a.Cd_TE=t.Cd_TE
	where '+@Cond+' order by a.Cd_Prod desc) as Producto order by Cd_Prod'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta productos pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro maximo & minimo de productos //ordenado por : Cd_Prod
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	set @sql = 'select top 1 @RMax =Cd_Prod from '+@Inter+' where  '+@Cond+' order by Cd_Prod/*ApPat,ApMat,RSocial*/ desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(7) output', @Max output

	set @sql = 'select @RMin = min(Cd_Prod) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Prod from '+@Inter+' where  '+@Cond+' order by Cd_Prod/*ApPat,ApMat,RSocial*/ desc) as Producto'
	exec sp_executesql @sql, N'@RMin nvarchar(7) output', @Min output
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro maximo & minimo de productos //ordenado por : Cd_Prod
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta 
			
	print @Max
	print @Min
	print @sql
	print @Consulta

print @msj
-- LEYENDA --
-- J :2010-10-11<Creacion del procedimiento almacenado>
-- MP : 22-02-2011 : <Modificacion del procedimiento almacenado>

/*
select * from Producto2
----Ejemplo-----
Declare @Max char(7),@Min char(7)
exec Inv_Producto2_explo_PagAnt1 '11111111111',5,'PD00040',@Max out,@Min out,3,null
*/












GO

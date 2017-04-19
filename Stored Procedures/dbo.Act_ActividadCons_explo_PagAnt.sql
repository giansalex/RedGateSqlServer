SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Act_ActividadCons_explo_PagAnt]
@FecD DATETIME,
@FecH DATETIME,
@Colum VARCHAR(100),
@Dato VARCHAR(100),
--------------------------------------
@TamPag INT, --Tamanio Pagina
@Ult_CdAct NVARCHAR(10),
@Max NVARCHAR(10) OUTPUT,
@Min NVARCHAR(10) OUTPUT,
--------------------------------------
@msj VARCHAR(100) OUTPUT
AS
SET LANGUAGE Spanish
	DECLARE @Inter VARCHAR(3000)

	--Interseccion
	SET @Inter = 'Actividad a inner join Empresa c on a.Ruc=c.Ruc
				  inner join Usuario t1 on a.Cd_TrabEnc=t1.NomUsu
				  inner join Usuario t2 on a.Cd_TrabRsp=t2.NomUsu
				  inner join EstadoAct ea on a.Cd_EA=ea.Cd_EA
				  inner join TipActividad ta on a.Cd_TA=ta.cd_TA'
		--SET @Inter = 'venta v inner join Moneda mo on mo.Cd_Mda=a.Cd_Mda
		--		left join FormaPC fp on fp.Cd_FPC=a.Cd_FPC
		--		inner join TipDoc td on td.Cd_TD=a.Cd_TD
		--		inner join Area ar on ar.RucE=a.RucE and ar.Cd_Area=a.Cd_Area
		--		left join Vendedor2 v2 on v2.RucE=a.RucE and v2.Cd_Vdr=a.Cd_Vdr
		--		left join Cliente2 c2 on c2.RucE=a.RucE and c2.Cd_Clt=a.Cd_Clt
		--		left join MtvoIngSal mis on mis.RucE=a.RucE and mis.Cd_MIS=a.Cd_MIS
		--		left join CCostos c on c.RucE = a.RucE and c.Cd_CC = a.Cd_CC
		--		left join CCSub s on c.RucE = s.RucE and c.Cd_CC = s.Cd_CC and s.Cd_SC = a.Cd_SC
		--		left join CCSubSub ss on c.RucE = ss.RucE and c.Cd_CC = ss.Cd_CC and s.Cd_SC = ss.Cd_SC and ss.Cd_SS = a.Cd_SS'
	
	DECLARE @Cond VARCHAR(5000)
	DECLARE @sql NVARCHAR(4000)
	--Condicion	
	IF(@FecD = '' OR @FecD IS NULL)
	BEGIN
		SET @Cond = 'a.Cd_Act < ' + CONVERT(NVARCHAR,ISNULL(@Ult_CdAct,'0')) +''
	END
	ELSE
	BEGIN
		SET @Cond = '(a.FecReg between '''+CONVERT(NVARCHAR,@FecD,103)+''' and '''+
		CONVERT(NVARCHAR,@FecH,103)+''') and a.Cd_Act < ' + CONVERT(NVARCHAR,ISNULL(@Ult_CdAct,'0')) +''
	END	
	IF(@Colum = 'Cd_Act') SET @Cond = @Cond+ ' and a.Cd_Act like '''+@Dato+''' '
	ELSE IF(@Colum = 'RSocial') SET @Cond = @Cond+ ' and a.Ruc like '''+@Dato+''' '
	ELSE IF(@Colum = 'Nom') SET @Cond =@Cond+ ' and a.Nom like '''+@Dato+''' '
	ELSE IF(@Colum = 'Descrip') SET @Cond = @Cond+' and a.Descrip like '''+@Dato+''' '
	ELSE IF(@Colum = 'DescripInc') SET @Cond = @Cond+' and a.DescripInc like '''+@Dato+''' '
	ELSE IF(@Colum = 'FecInc') SET @Cond = @Cond+' and Convert(nvarchar,a.FecInc,103) like '''+@Dato+''' '
	ELSE IF(@Colum = 'FecInicio') SET @Cond = @Cond+' and Convert(nvarchar,a.FecInicio,103) like '''+@Dato+''' '
	ELSE IF(@Colum = 'HrsEstm') SET @Cond = @Cond+' and a.HrsEstm like '''+@Dato+''' '
	ELSE IF(@Colum = 'HrsReales') SET @Cond = @Cond+' and a.HrsReales like '''+@Dato+''' '
	ELSE IF(@Colum = 'FecFin') SET @Cond = @Cond+' and Convert(nvarchar,a.FecFin,103) like '''+@Dato+''' '
	ELSE IF(@Colum = 'Prdad1L2L') SET @Cond = @Cond+' and a.Prdad1L2L like '''+@Dato+''' '
	ELSE IF(@Colum = 'Prdad4L') SET @Cond = @Cond+' and a.Prdad4L like '''+@Dato+''' '
	ELSE IF(@Colum = 'PorcAvzdo') SET @Cond = @Cond+' and a.PorcAvzdo like '''+@Dato+''' '
	ELSE IF(@Colum = 'Predec') SET @Cond = @Cond+' and a.Predec like '''+@Dato+''' '
	ELSE IF(@Colum = 'Cd_TrabRsp') SET @Cond = @Cond+' and a.Cd_TrabRsp like '''+@Dato+''' '
	ELSE IF(@Colum = 'Cd_TrabEnc') SET @Cond = @Cond+' and a.Cd_TrabEnc like '''+@Dato+''' '
	ELSE IF(@Colum = 'Cd_TA') SET @Cond = @Cond+' and a.Cd_TA like '''+@Dato+''' '
	ELSE IF(@Colum = 'Cd_EA') SET @Cond = @Cond+' and a.Cd_EA like '''+@Dato+''' '
	ELSE IF(@Colum = 'FecReg') SET @Cond = @Cond+' and Convert(nvarchar,a.FecReg,103) like '''+@Dato+''' '
	ELSE IF(@Colum = 'UsuCrea') SET @Cond = @Cond+' and a.UsuCrea like '''+@Dato+''' '
	ELSE IF(@Colum = 'FecMdf') SET @Cond = @Cond+' and Convert(nvarchar,a.FecMdf,103) like '''+@Dato+''' '
	ELSE IF(@Colum = 'UsuMdf') SET @Cond = @Cond+' and a.UsuMdf like '''+@Dato+''' '

	DECLARE @Consulta VARCHAR(8000)
		SET @Consulta='	select *from(	select top '+CONVERT(NVARCHAR,@TamPag)+'
				a.Cd_Act, c.RSocial, a.Nom, a.Descrip, a.DescripInc, Convert(nvarchar,a.FecInc,103) as FecInc, Convert(nvarchar,a.FecInicio,103) as FecInicio,a.HrsEstm, a.HrsReales, Convert(nvarchar,a.FecFin,103) as FecFin, a.Prdad1L2L, a.Prdad4L,
				a.PorcAvzdo, a.Predec, t2.NomComp as Responsable, t1.NomComp as Encargado, ta.Descrip as TipoActividad, ea.Descrip as EstadoActividad, Convert(nvarchar,a.FecReg,103) as FecReg, a.UsuCrea, Convert(nvarchar,a.FecMdf,103) as FecMdf, a.UsuMdf
				from
				' +@Inter+' where 
				'+@Cond + ' order by a.Cd_Act desc) as Venta order by Cd_Act '
PRINT @Consulta
	IF NOT EXISTS (SELECT TOP 1 * FROM Actividad)
		SET @msj = 'No se encontraron Actividades registradas'
	ELSE
	  BEGIN
		EXEC (@Consulta)

		  SET @sql = 'select top 1 @RMax = Cd_Act from ' + @Inter + ' where ' +@Cond+' order by Cd_Act desc'
		  EXEC sp_executesql @sql, N'@RMax char(12) output', @Max OUTPUT

		  SET @sql = 'select @RMin = min(Cd_Act) from(select top '+ CONVERT(NVARCHAR,@TamPag)+' Cd_Act  from ' + @Inter + ' where ' + @Cond +' order by Cd_Act desc) as  Venta'
		  EXEC sp_executesql @sql, N'@RMin char(12) output',@Min OUTPUT

	  END
GO

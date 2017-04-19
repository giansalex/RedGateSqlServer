SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Prd_FormulaCons_explo_PagSig]
@RucE nvarchar(11),
@TamPag int, 	--TamaÃƒÂ±o Pagina
@Ult_NroFor char(7),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(7) output,
@Min char(7) output,
@msj varchar(100) output
as
	
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Tablas que almacena
			las tablas que se intersectarÃƒÂ¡n en la consulta
			-----------------------------------------------------------------------------------------------*/
			--declare @Tablas varchar(1000)
			--set @Tablas = ' Formula f'
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Condicion que almacena
			la condiciÃƒÂ³n de la sentencia Where de la consulta
			que se realizarÃƒÂ¡
			-----------------------------------------------------------------------------------------------*/
			declare @Condicion varchar(1000)
			set @Condicion = 'f.RucE= '''+@RucE+''' and f.Cd_Prod>'''+convert(nvarchar,isnull(@Ult_NroFor,''))+''''
			--print 1
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Consulta que almacena
			la consulta y se implementan las variables 
			@Tablas & @Condicion
			-----------------------------------------------------------------------------------------------*/
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select top '+Convert(nvarchar,@TamPag)+ 
			' f.RucE,f.Cd_Prod, f.Nombre1, f.Descrip from user321.ProdXFormula f
			 where '+ @Condicion+' 
			 order by f.Cd_Prod'
			--print @consulta
			Exec (@Consulta)
			--print @Consulta	
		
		--
		/*CREATE VIEW ProdXFormula as 
		select max(f.Ruce) as RucE,f.Cd_Prod, max(p.Nombre1) as Nombre1, max(f.Descrip) as Descrip from Formula f
			 left join producto2 p on p.RucE=f.RucE and p.Cd_Prod=f.Cd_Prod
			 left join Prod_UM pum on pum.RucE=f.RucE and pum.Cd_Prod=f.Cd_Prod and pum.ID_UMP=f.ID_UMP
			 group by f.Cd_Prod
		select * from ProdXFormula*/
		--
		
		if (@Ult_NroFor='' or @Ult_NroFor is null)
			begin
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count(f.Cd_Prod) from user321.ProdXFormula f  where ' + @Condicion
				exec sp_executesql @sql, N'@Regs int output', @NroRegs output
				select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
			end
	
				set @sql = 'select @RMax = max(Cd_Prod) from (select top '+Convert(nvarchar,@TamPag)+' f.Cd_Prod from user321.ProdXFormula f where '+@Condicion+' order by f.Cd_Prod) as Cd_Prod'
				exec sp_executesql @sql, N'@RMax char(7) output', @Max output

				set @sql = 'select top 1 @RMin =f.Cd_Prod from user321.ProdXFormula f where '+@Condicion+' order by f.Cd_Prod'
				exec sp_executesql @sql, N'@RMin char(7) output', @Min output

print @msj
print @Max
print @Min




----------------------LEYENDA----------------------
--FL : Mar 10-02-2011 <creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Seg_GrupoPermCons_explo_PagSig 'usudemo','20508378390',100,'',null,null,null,null,null
CREATE procedure [dbo].[Seg_GrupoPermCons_explo_PagSig]
@NomUsu nvarchar(20),
@RucE nvarchar(11),
@TamPag int, 	--TamaÃƒÆ’Ã‚Â±o Pagina
@Ult_NroFor char(7),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(7) output,
@Min char(7) output,
@msj varchar(100) output
as
			declare @nivel varchar(100)
			select @nivel = Nivel from Usuario
			where NomUsu = @NomUsu
			print @NomUsu
			Print @nivel
			
			declare @Condicion varchar(1000)
			set @Condicion = ' Cd_Prf in (select distinct usu.Cd_Prf from Usuario usu
			inner join Perfil prf on usu.Cd_Prf = prf.Cd_Prf
			where usu.Nivel like '''+@nivel+''' + ''%'')
			and f.Cd_GP>'''+convert(nvarchar,isnull(@Ult_NroFor,''))+''''
			
			print @Condicion
			--print @Condicion
			/*-----------------------------------------------------------------------------------------------
			Declaramos la variable @Consulta que almacena
			la consulta y se implementan las variables 
			@Tablas & @Condicion
			-----------------------------------------------------------------------------------------------*/
			declare @Consulta nvarchar(4000)
			set @Consulta = '	select distinct top '+Convert(nvarchar,@TamPag)+ 
			' f.Cd_GP,f.Descrip,f.Estado,CantGP=(select count(*) from Usuario u
			left join PermisosE a on a.Cd_Prf=u.Cd_Prf
			where a.RucE='''+@RucE+''' and a.Cd_GP=f.Cd_GP) from GrupoPermisos f
			inner join PermisosE a on a.Cd_GP=f.Cd_GP
			 where '+ @Condicion+' 
			 order by f.Cd_GP'
			Exec (@Consulta)
			print @consulta		
		
		if (@Ult_NroFor='' or @Ult_NroFor is null)
			begin
				declare @sql nvarchar(1000)
				set @sql= 'select @Regs = count( distinct f.Cd_GP) from GrupoPermisos f left join PermisosE a on a.Cd_GP=f.Cd_GP where ' + @Condicion
				exec sp_executesql @sql, N'@Regs int output', @NroRegs output
				select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
			end
	
				set @sql = 'select @RMax = max(Cd_GP) from (select distinct top '+Convert(nvarchar,@TamPag)+' f.Cd_GP from GrupoPermisos f left join PermisosE a on a.Cd_GP=f.Cd_GP where '+@Condicion+' order by f.Cd_GP) as Cd_GP'
				exec sp_executesql @sql, N'@RMax char(7) output', @Max output

				set @sql = 'select top 1 @RMin =f.Cd_GP from GrupoPermisos f left join PermisosE a on a.Cd_GP=f.Cd_GP where '+@Condicion+' order by f.Cd_GP'
				exec sp_executesql @sql, N'@RMin char(7) output', @Min output

print @msj
print @Max
print @Min




----------------------LEYENDA----------------------
--FL : Lun 30-05-2011 <creacion del procedimiento almacenado>


GO

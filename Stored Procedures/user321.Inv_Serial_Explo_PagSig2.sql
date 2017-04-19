SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [user321].[Inv_Serial_Explo_PagSig2]
@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
------------------------
@TamPag int,
@Ult_Sig char(107),
@NroRegs int output,
@NroPags int output,
@Max char(107)output,
@Min char(107)output,
@check bit,
-------------------------
@msj varchar(100) output
as
				declare @Inter varchar(4000)

				set @Inter='user321.VSerial_Explorador'
					print @Inter
				declare @Cond varchar(4000)
				declare @sql nvarchar(4000)

				set @Cond='RucE='''+@RucE+''' and (FecIng between '''+ Convert(varchar,@FecD,103)+''' and '''+ Convert(varchar,@FecH,103)
					+''') and siguient >'''+isnull(@Ult_Sig,'')+''''
					print @Cond
				if(@Colum = 'Cd_Prod') set @Cond=@Cond+' and Cd_Prod like '''+@Dato+''''
				else if(@Colum='Producto') set @Cond=@Cond+' and Producto like '''+@Dato+''''
				else if(@Colum='Serial') set @Cond=@Cond+' and Serial like '''+@Dato+''''
				else if(@Colum='Lote') set @Cond=@Cond+' and Lote like '''+@Dato+''''
				else if(@Colum='Cd_AlmAct') set @Cond=@Cond+' and Cd_AlmAct like '''+@Dato+''''
				else if(@Colum='CodAlm') set @Cond=@Cond+' and CodAlm like '''+@Dato+''''
				else if(@Colum='Almacen') set @Cond=@Cond+' and Almacen like '''+@Dato+''''
				else if(@Colum='FecIng') set @Cond=@Cond+' and FecIng like '''+@Dato+''''
				else if(@Colum='FecSal') set @Cond=@Cond+' and FecSal like '''+@Dato+''''
				
				
				declare @Consulta varchar(4000)
if(@check= 0)
	begin

				
				Set @Consulta ='select top '+Convert(nvarchar,@TamPag)+'
					Cd_Prod,CodCo1_,Producto,Serial,Lote,Cd_AlmAct,CodAlm,Almacen,FecIng,FecSal,Siguient
					from '+@Inter+ ' Where '+@Cond + ' and Serial in (select serial from serialmov where ruce='+@RucE+' )' + ' Order by Siguient'

				Print @Consulta
				exec(@Consulta)

				if(@Ult_Sig is null)
				begin
					set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
					exec sp_executesql @sql, N'@Regs int output', @NroRegs output
					select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
				end
				set @sql = 'select @RMax = max(Siguient) from(select top '+Convert(nvarchar,@TamPag)+' siguient from '+@Inter+' where '+@Cond+' order by Siguient) as Serial'
				exec sp_executesql @sql, N'@RMax char(107) output', @Max output

				set @sql = 'select top 1 @RMin =Siguient from '+@Inter+' where '+@Cond+' order by Siguient'
				exec sp_executesql @sql, N'@RMin char(107) output', @Min output
	end
else if(@check= 1)
	begin
		
				Set @Consulta ='select top '+Convert(nvarchar,@TamPag)+'
					Cd_Prod,Producto,Serial,Lote,Cd_AlmAct,CodAlm,Almacen,FecIng,FecSal,Siguient
					from '+@Inter+ ' Where '+@Cond +' Order by Siguient'

				Print @Consulta
				exec(@Consulta)

				if(@Ult_Sig is null)
				begin
					set @sql= 'select @Regs = count(*) from '+@Inter+ '  where ' + @Cond
					exec sp_executesql @sql, N'@Regs int output', @NroRegs output
					select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
				end
				set @sql = 'select @RMax = max(Siguient) from(select top '+Convert(nvarchar,@TamPag)+' siguient from '+@Inter+' where '+@Cond+' order by Siguient) as Serial'
				exec sp_executesql @sql, N'@RMax char(107) output', @Max output

				set @sql = 'select top 1 @RMin =Siguient from '+@Inter+' where '+@Cond+' order by Siguient'
				exec sp_executesql @sql, N'@RMin char(107) output', @Min output
	end


/*
select *from user321.VSerial_Explorador 
order by Cd_Prod, Serial

select *from Serial
select *from SerialMov
exec user321.Inv_Serial_Explo_PagSig2 '11111111111','01/06/2012','30/06/2012',null,null,50,null,null,null,null,null,false,null

*/








GO

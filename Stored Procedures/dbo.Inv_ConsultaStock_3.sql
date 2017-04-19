SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_ConsultaStock_3]
@RucE nvarchar(11),
@msj varchar(100) output,
@FecD datetime,
@FecH datetime,
@Cod_Alm varchar(20)
as
set @msj = 'Procedimiento Inv_ConsultaStock_3 fue deshabilitado. Contacte a sistemas.'
-- cam dice: Keyner para que carajo creaste este SP si no se usa!!!!

/*
declare @Cd_Alm varchar(20)
declare @Alm varchar(4000)
declare @AlmAux varchar(4000)
declare @prueba1 varchar(4000)
declare @prueba2 varchar(4000)
declare @prueba3 varchar(4000)
declare @prueba4 varchar(4000)
declare @prueba5 varchar(4000)

set @Alm = ''
set @AlmAux = ''
if(@Cod_Alm = '' or @Cod_Alm is null)
begin
	select @Alm = COALESCE(@Alm + Cd_Alm,Cd_Alm)
	from Almacen where RucE = @RucE and Cd_Alm in (select  distinct Cd_Alm from  Inventario where RucE = @RucE)  order by Cd_Alm
end
else
begin
	select @Alm = COALESCE(@Alm + Cd_Alm,Cd_Alm)
	from Almacen where RucE = @RucE and Cd_Alm in (select  distinct Cd_Alm from  Inventario where RucE = @RucE and Cd_Alm = @Cod_Alm)  order by Cd_Alm
end

print @Alm
set @Alm +='A'
set @AlmAux = @Alm
print '@Alm: ' + @Alm
--set @Alm =@AlmAux
set @Cd_Alm = ''
declare @col varchar(4000)
set @col = ''
while(len(@Alm) >0)  
begin
	if(left(@Alm, 1)='A')
		if(@Cd_Alm != '')
		begin
			set @col += ', case Cd_Alm when '''+@Cd_Alm+''' then Cant else 0 end  as '+@Cd_Alm 
			set @Cd_Alm = ''
		end
	set @Cd_Alm += left(@Alm, 1)
	set @Alm = right(@Alm, len(@Alm)-1)  
end  
set @Alm =@AlmAux
set @Cd_Alm = ''
declare @col2 varchar(8000)
set @col2 = ''
while(len(@Alm) >0)  
begin
	if(left(@Alm, 1)='A')
		if(@Cd_Alm != '')
		begin
			set @col2 += ', '+@Cd_Alm+' as '''+(select Cd_Alm+'-'+Nombre from Almacen where RucE = @RucE and Cd_Alm =@Cd_Alm)+''''
			set @Cd_Alm = ''
		end
	set @Cd_Alm += left(@Alm, 1)
	set @Alm = right(@Alm, len(@Alm)-1)  
end  
set @Alm =@AlmAux
set @Cd_Alm = ''
declare @col1 varchar(8000)
set @col1 = ''
while(len(@Alm) >0)  
begin
	if(left(@Alm, 1)='A')
		if(@Cd_Alm != '')
		begin
			set @col1 += ', Sum('+@Cd_Alm+') as '''+@Cd_Alm+''''
			set @Cd_Alm = ''
		end
	set @Cd_Alm += left(@Alm, 1)
	set @Alm = right(@Alm, len(@Alm)-1)  
end  
if(@RucE = '20546110720')-- NORSUR
	if(@Cod_Alm = '' or @Cod_Alm is null)
		begin
		set @prueba1 = 
		 ('select P.Cd_Prod as Codigo, T3.ID_UMP,  P.CodCo1_ as ''Codigo Comer.'',P.Nombre1 + '' '' + U.DescripAlt as Producto,Cant as Cantidad'+@col2+' from ( 
				select Cd_Prod, ID_UMP, Sum(Cant) as Cant '+@Col1+' from ( 
					select *'+@col+' from (
						select Cd_Alm, Cd_Prod, ID_UMP, sum(Cant_Ing) as Cant from Inventario where RucE = '''+@RucE+''' and FecMov between '''+@FecD+''' and '''+@FecH+''' group by Cd_Prod, Cd_Alm, ID_UMP)
					as T1 
				) as T2 group by Cd_Prod, ID_UMP
			) as T3
			inner join Producto2 as P on P.RucE = '''+@RucE+''' and P.Cd_Prod = T3.Cd_Prod
			inner join Prod_UM as U on P.RucE = U.RucE and P.Cd_Prod = u.Cd_Prod and T3.ID_UMP = U.ID_UMP
			order by P.Cd_Prod')
			
		exec (@prueba1)
		print @prueba1
		end
	else
		begin
		set @prueba2 =
			 ('select P.Cd_Prod as Codigo, T3.ID_UMP,  P.CodCo1_ as ''Codigo Comer.'',P.Nombre1 + '' '' + U.DescripAlt as Producto,Cant as Cantidad'+@col2+' from ( 
				select Cd_Prod, ID_UMP, Sum(Cant) as Cant '+@Col1+' from ( 
					select *'+@col+' from (
						select Cd_Alm, Cd_Prod, ID_UMP, sum(Cant_Ing) as Cant from Inventario where RucE = '''+@RucE+''' and Cd_Alm='''+@Cod_Alm+''' and FecMov between '''+@FecD+''' and '''+@FecH+''' group by Cd_Prod, Cd_Alm, ID_UMP)
					as T1 
				) as T2 group by Cd_Prod, ID_UMP
			) as T3
			inner join Producto2 as P on P.RucE = '''+@RucE+''' and P.Cd_Prod = T3.Cd_Prod
			inner join Prod_UM as U on P.RucE = U.RucE and P.Cd_Prod = u.Cd_Prod and T3.ID_UMP = U.ID_UMP
			order by P.Cd_Prod')
			
	    exec (@prueba2)
	    print @prueba2
		end
else
	if(@Cod_Alm = '' or @Cod_Alm is null)
		begin
			set @prueba3= ('select P.Cd_Prod as Codigo, P.CodCo1_ as ''Codigo Comer.'',P.Nombre1 as Producto,Cant as Cantidad'+@col2+' from ( 
				select Cd_Prod, Sum(Cant) as Cant '+@Col1+' from ( 
					select *'+@col+' from (
						select Cd_Alm, Cd_Prod, sum(Cant) as Cant from Inventario where RucE = '''+@RucE+''' and FecMov between '''+@FecD+''' and '''+@FecH+''' group by Cd_Prod, Cd_Alm)
					as T1 
				) as T2 group by Cd_Prod
			) as T3
			inner join Producto2 as P on P.RucE = '''+@RucE+''' and P.Cd_Prod = T3.Cd_Prod
			order by P.Cd_Prod')
			
			exec (@prueba3)
			print @prueba3
		end
	else	
		begin
			set @prueba4 = ('select P.Cd_Prod as Codigo, P.CodCo1_ as ''Codigo Comer.'',P.Nombre1 as Producto,Cant as Cantidad'+@col2+' from ( 
				select Cd_Prod, Sum(Cant) as Cant '+@Col1+' from ( 
					select *'+@col+' from (
						select Cd_Alm, Cd_Prod, sum(Cant) as Cant from Inventario where RucE = '''+@RucE+''' and Cd_Alm='''+@Cod_Alm+''' and FecMov between '''+@FecD+''' and '''+@FecH+''' group by Cd_Prod, Cd_Alm)
					as T1 
				) as T2 group by Cd_Prod
			) as T3
			inner join Producto2 as P on P.RucE = '''+@RucE+''' and P.Cd_Prod = T3.Cd_Prod
			order by P.Cd_Prod')
			print @prueba4
			exec (@prueba4)
		end
		*/
-- prueba
--exec Inv_ConsultaStock_3 '11111111111',null,'01/09/2012','27/09/2012',null
GO

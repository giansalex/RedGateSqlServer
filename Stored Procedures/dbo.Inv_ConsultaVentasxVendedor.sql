SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_ConsultaVentasxVendedor]
@RucE nvarchar(11),
@FecIni datetime,
@FecFin datetime,
@Cd_Area nvarchar(6),
@Cd_CodVdr varchar(7),
@msj varchar(100) output  

as
set language 'spanish'
declare @Cd_Vdr varchar(7)
declare @Vdr varchar(4000)
declare @col2 varchar(8000)
declare @VdrAux varchar(4000)
declare @Cant varchar(4000)
set @Vdr = ''

if(@Cd_CodVdr is null or @Cd_CodVdr = '')
begin
	select @Vdr = COALESCE(@Vdr + Cd_Vdr,Cd_vdr)
	from Vendedor2 where RucE = @RucE and Cd_Vdr in (select  distinct Cd_Vdr from  Venta where RucE = @RucE and FecMov between convert(datetime,@FecIni) and convert(datetime,@FecFin))  order by Cd_Vdr
end
else
begin
	set @Vdr = @Cd_CodVdr
end

print '@Vdr: ' + @Vdr
set @VdrAux = @Vdr
set @Vdr +='V'
-------------------------------------------------------------------------------------------------------------------------
--print '@Vdr: ' + @Vdr
set @Cd_Vdr = ''
declare @col varchar(4000)
set @col = ''
while(len(@Vdr) >0)  
begin
	if(left(@Vdr, 1)='V')
		if(@Cd_Vdr != '')
		begin
			set @col += ', case Cd_Vdr when '''+@Cd_Vdr+''' then Total else 0 end  as '+@Cd_Vdr+', case Cd_Vdr when '''+@Cd_Vdr+''' then Cantidad else 0 end  as Cant'+@Cd_Vdr
			set @Cd_Vdr = ''
		end
	set @Cd_Vdr += left(@Vdr, 7)
	set @Vdr = right(@Vdr, len(@Vdr)-1) 
end  
print '@col: ' + @col


set @Vdr = @VdrAux
set @Vdr +='V'
set @col2 = '' set @Cd_Vdr = ''
while(len(@Vdr) >0)  
begin
	if(left(@Vdr, 1)='V')
		if(@Cd_Vdr != '')
		begin
			set @col2 += ', '+@Cd_Vdr+' as '''+(select Cd_Vdr+' - '+ case(isnull(len(RSocial),0))
	                     when 0 then ApPat+' '+ApMat+' '+Nom
		       else RSocial end as CodNom from Vendedor2 where RucE = @RucE and Cd_Vdr =@Cd_Vdr)+''''
			set @Cd_Vdr = ''
		end
	set @Cd_Vdr += left(@Vdr, 7)
	set @Vdr = right(@Vdr, len(@Vdr)-1)  
end  
print '@col2' + @col2
------------------------------------------------------------------------------------------------------------------
set @Vdr =@VdrAux
set @Cd_vdr = ''
set @Vdr +='V'
declare @col1 varchar(8000)
set @col1 = ''
while(len(@Vdr) >0)  
begin
	if(left(@Vdr, 1)='V')
		if(@Cd_Vdr != '')
		begin
			set @col1 += ', Sum('+@Cd_Vdr+') as '''+@Cd_Vdr+''''
			set @Cd_Vdr = ''
		end
	set @Cd_Vdr += left(@Vdr, 7)
	set @Vdr = right(@Vdr, len(@Vdr)-1)  
end  
print '@col1: ' + @col1
---------------------------------------------------------------------------------------------------------------------------------
-- Cantidad
set @Cd_Vdr = ''
declare @col3 varchar(4000)
set @col3 = ''
while(len(@Vdr) >0)  
begin
	if(left(@Vdr, 1)='V')
		if(@Cd_Vdr != '')
		begin
			set @col += ', case Cd_Vdr when '''+@Cd_Vdr+''' then Cantidad else 0 end  as '+@Cd_Vdr 
			set @Cd_Vdr = ''
		end
	set @Cd_Vdr += left(@Vdr, 7)
	set @Vdr = right(@Vdr, len(@Vdr)-1) 
end  
print '@col: ' + @col

-- exec Inv_ConsultaVentasxVendedor '11111111111','01/05/2012 00:00:00','31/05/2012 23:59:29','0001',null,null


---------------------------------------------------------------------------------------------------------------------------------
-- EXEC
declare @sentencia varchar(8000)
set @sentencia = '
select
isnull(l1.Nombre,''--Sin Especificar--'') As NomClase, isnull(l2.Nombre,''--Sin Especificar--'') As NomClaseSub,
isnull(l3.Nombre,''--Sin Especificar--'') As NomClaseSubSub, 
P.Cd_Prod as Codigo, P.CodCo1_ as CodCom,P.Nombre1 as Producto'+@col2+' ,Cantidad, Total as Total from ( 
select Cd_Prod,sum(Total) as Total '+ @col1 +',sum(Cantidad) as Cantidad from(
select *'+@col+'
 from (
select v.Cd_Vdr,d.Cd_Prod, sum(d.Cant) as Cantidad, sum(d.Total) as Total from Venta v
LEFT join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
where v.RucE = '''+@RucE+''' and v.Cd_Area ='''+@Cd_Area+''' and v.FecMov between '''+ Convert(varchar,@FecIni)+''' and '''+ Convert(varchar,@FecFin)+'''/* + ''23:59:29''*/
group by v.Cd_Vdr,d.Cd_Prod
) as T1) as T2 group by Cd_Prod) as T3
inner join Producto2 as P on P.RucE = '''+@RucE+''' and P.Cd_Prod = T3.Cd_Prod
Left Join ClaseSubSub l3 On l3.RucE=P.RucE and l3.Cd_CL=P.Cd_CL and l3.Cd_CLS=P.Cd_CLS and l3.Cd_CLSS=P.Cd_CLSS
Left Join ClaseSub l2 On l2.RucE=P.RucE and l2.Cd_CL=P.Cd_CL and l2.Cd_CLS=P.Cd_CLS
Left Join Clase l1 On l1.RucE=P.RucE and l1.Cd_CL=P.Cd_CL	
where P.RucE = '''+@RucE+'''
order by P.Cd_Prod
'
print @sentencia
exec (@sentencia)
-- LEYENDA
-- Cam 22/02/2012 Creacion del SP "NO TENGO LAS TECLAS MAYOR, MENOR EN MI TECLADO"
-- exec Inv_ConsultaVentasxVendedor '11111111111','01/05/2012 00:00:00','31/05/2012 23:59:29','0001',null,null

GO

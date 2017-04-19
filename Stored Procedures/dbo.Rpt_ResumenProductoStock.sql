SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--declare 
CREATE procedure [dbo].[Rpt_ResumenProductoStock]
@RucE nvarchar(11)
,@FecIni datetime
,@FecFin datetime
,@Cd_CL nvarchar(10)
,@Cd_CLS nvarchar(10)
,@Cd_CLSS nvarchar(10)
,@Cd_Alm nvarchar(50)

as
--set @RucE = '20102028687'
--set @FecIni = '01/09/2012'
--set @FecFin = '31/12/2012'
--set @Cd_CL = ''
--set @Cd_CLS = ''
--set @Cd_CLSS = ''

select *,'DEL '+Convert(nvarchar,@FecIni,103)+' AL '+Convert(nvarchar,@FecFin,103) as FechaConsulta from Empresa where Ruc = @RucE
 
select s.*,ant.Cd_Alm, isnull(ant.Suma_Cantidad,0.0) as StockInicial, (isnull(ant.Suma_Cantidad,0.0) - isnull(s.Salida,0.0) + isnull(s.Entrada,0.0)) as StockActual from
      (          
            select
             p.Cd_Prod 
             ,p.CodCo1_ as CodCom
             ,p.Nombre1 as Nombre
             ,p.Descrip
             ,p.Cd_CL
             ,cl.Nombre as NomCL
             ,cl.NCorto as NCortoCL
             ,cls.Nombre as NomCLS
             , a.Cd_Alm+'-'+alm.Nombre as Cd_Alm
             ,cls.NCorto as NCortoCLS,
            sum(Case(a.IC_ES) when 'E' then a.Cant else 0 end) as Entrada,
            abs(sum(Case(a.IC_ES) when 'S' then Cant else 0 end)) as Salida
            from Inventario a
            left join Producto2 p on p.RucE = a.RucE and a.Cd_Prod = p.Cd_Prod
            left join Clase cl on p.RucE = cl.RucE and p.Cd_CL = cl.Cd_CL
            left join ClaseSub cls on p.RucE = cls.RucE and p.Cd_CL = cls.Cd_CL and p.Cd_CLS = cls.Cd_CLS
            left join Almacen alm on alm.RucE = a.RucE and alm.Cd_Alm = a.Cd_Alm
            where a.RucE=@RucE and a.FecMov between @FecIni and @FecFin+' 23:59:29'
            and case when isnull(@Cd_CL,'')='' then isnull(@Cd_CL,'') else p.Cd_CL end = isnull(@Cd_CL,'')
            and case when isnull(@Cd_CLS,'')='' then isnull(@Cd_CLS,'') else p.Cd_CLS end = isnull(@Cd_CLS,'')
            and case when isnull(@Cd_CLSS,'')='' then isnull(@Cd_CLSS,'') else p.Cd_CLSS end = isnull(@Cd_CLSS,'')
            and case when isnull(@Cd_Alm,'')='' then isnull(@Cd_Alm,'') else a.Cd_Alm end = isnull(@Cd_Alm,'')
        
            group by --a.Cd_Prod,a.Cd_Alm
            a.Cd_Alm+'-'+alm.Nombre,p.Cd_Prod,p.CodCo1_,p.Nombre1,p.Descrip,p.Cd_CL,cl.Nombre,cl.NCorto,cls.Nombre,cls.NCorto, a.Cd_Alm
            
      ) as s
      left join
      (    
            select a.Cd_Alm+'-'+alm.Nombre as Cd_Alm, p.Cd_Prod,p.CodCo1_ as CodCom,p.Nombre1 as Nombre,p.Descrip,p.Cd_CL,cl.Nombre as NomCL,cl.NCorto as NCortoCL,cls.Nombre as NomCLS,cls.NCorto as NCortoCLS,
            sum(Case(a.IC_ES) when 'E' then a.Cant else 0 end) as Entrada,
            abs(sum(Case(a.IC_ES) when 'S' then Cant else 0 end)) as Salida,
            sum(Case(a.IC_ES) when 'E' then a.Cant else 0 end) - sum(Case(a.IC_ES) when 'S' then abs(Cant) else 0 end) as Suma_Cantidad
            from Inventario a
            left join Producto2 p on p.RucE = a.RucE and a.Cd_Prod = p.Cd_Prod
            left join Clase cl on p.RucE = cl.RucE and p.Cd_CL = cl.Cd_CL
            left join ClaseSub cls on p.RucE = cls.RucE and p.Cd_CL = cls.Cd_CL and p.Cd_CLS = cls.Cd_CLS
            left join Almacen alm on alm.RucE = a.RucE and alm.Cd_Alm = a.Cd_Alm
            where a.RucE=@RucE and a.FecMov <@FecIni--between @FecIni and @FecFin+' 23:59:29'
            and case when isnull(@Cd_CL,'')='' then isnull(@Cd_CL,'') else p.Cd_CL end = isnull(@Cd_CL,'')
            and case when isnull(@Cd_CLS,'')='' then isnull(@Cd_CLS,'') else p.Cd_CLS end = isnull(@Cd_CLS,'')
            and case when isnull(@Cd_CLSS,'')='' then isnull(@Cd_CLSS,'') else p.Cd_CLSS end = isnull(@Cd_CLSS,'')
            and case when isnull(@Cd_Alm,'')='' then isnull(@Cd_Alm,'') else a.Cd_Alm end = isnull(@Cd_Alm,'')
            group by a.Cd_Prod,a.Cd_Alm+'-'+alm.Nombre, p.Cd_Prod, p.CodCo1_, p.Nombre1, p.Descrip,p.cd_cl, cl.Nombre, cl.NCorto, cls.Nombre, cls.NCorto, a.Cd_Alm
      ) as ant on ant.Cd_Prod = s.Cd_Prod
	

	
--<Creado: JA 19/12/2012>
--<Mod: RG 14/02/2013>
--	Exec Rpt_ResumenProductoStock '20102028687','01/09/2012','31/12/2012'   ,''       ,''         ,''       ,''
--	Exec Rpt_ResumenProductoStock RUC______EMP, FECHA_INICIO,FECHA_FINAL, Cd_CL,    CD_CLS,     CD_CLSS,  CD_ALAM
GO

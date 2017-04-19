SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 --exec User321.Rpt_RegCostos '11111111111','09','09',null
CREATE Procedure [user321].[Rpt_RegCostos]
@RucE nvarchar(11),
@FecD char(2),
@FecH char(2),
@msj varchar(100) output
as


	if not exists (select top 1 * from CptoCostoOF where RucE=@RucE)
		set @msj='No existen registros de Conceptos de Costo'
	else 
	begin
		--Detalles
		
select 
	Max(RucE) As RucE,
	Cd_Cos,
	Descrip,
	Sum(Ene) As Ene,
	Sum(Feb) As Feb,
	Sum(Mar) As Mar,
	Sum(Abr) As Abr,
	Sum(May) As May,
	SUM(Jun) Jun,
	SUM(Jul) Jul,
	SUM(Ago) Ago,
	SUM(Spt) Spt,
	SUM(Oct) Oct,
	SUM(Nov) Nov,
	SUM(Dic) Dic,
	Max(FecE) FecE

from
(
	select 
		RucE, Cd_Cos,Case(len(CodSNT_)) when 4 then Descrip else Descrip end as Descrip,0.00 as Ene,0.00 as Feb,0.00 as Mar,
		0.00 as Abr,0.00 as May,0.00 as Jun,0.00 as Jul,0.00 as Ago
		,0.00 as Spt,0.00 as Oct,0.00 as Nov,0.00 as Dic,null FecE,CodSNT_
	from CptoCosto as z where z.RucE=@RucE
	union all
	Select * From (
	select 
			Max(b.RucE) RucE, 
			Max(b.Cd_Cos) Cd_Cos, 
			Case(len(Max(c.CodSNT_))) when 4 then Max(c.Descrip) else Max(c.Descrip) end as Descrip,
			SUM(b.Ene) Ene,
			SUM(b.Feb) Feb,
			SUM(b.Mar) Mar,
			SUM(b.Abr) Abr,
			SUM(b.May) May,
			SUM(b.Jun) Jun,
			SUM(b.Jul) Jul,
			SUM(b.Ago) Ago,
			SUM(b.Spt) Spt,
			SUM(b.Oct) Oct,
			SUM(b.Nov) Nov,
			SUM(b.Dic) Dic,
			Max(b.FecE) FecE,
			Max(b.CodSNT_) CodSNT_
	from	
			(Select 
				*
			 from 
				(select 
						Max(ORF.RucE) RucE,
						Max(COF.Cd_Cos) Cd_Cos,
						Max(CC.CodSNT_) CodSNT_,
						Sum(Case When Month(ORF.FecE)=1 Then Isnull(COF.Costo,0) Else 0.00 End) As Ene,
						Sum(Case When Month(ORF.FecE)=2 Then Isnull(COF.Costo,0) Else 0.00 End) As Feb,
						Sum(Case When Month(ORF.FecE)=3 Then Isnull(COF.Costo,0) Else 0.00 End) As Mar,
						Sum(Case When Month(ORF.FecE)=4 Then Isnull(COF.Costo,0) Else 0.00 End) As Abr,
						Sum(Case When Month(ORF.FecE)=5 Then Isnull(COF.Costo,0) Else 0.00 End) As May,
						Sum(Case When Month(ORF.FecE)=6 Then Isnull(COF.Costo,0) Else 0.00 End) As Jun,
						Sum(Case When Month(ORF.FecE)=7 Then Isnull(COF.Costo,0) Else 0.00 End) As Jul,
						Sum(Case When Month(ORF.FecE)=8 Then Isnull(COF.Costo,0) Else 0.00 End) As Ago,
						Sum(Case When Month(ORF.FecE)=9 Then Isnull(COF.Costo,0) Else 0.00 End) As Spt,
						Sum(Case When Month(ORF.FecE)=10 Then Isnull(COF.Costo,0) Else 0.00 End) As Oct,
						Sum(Case When Month(ORF.FecE)=11 Then Isnull(COF.Costo,0) Else 0.00 End) As Nov,
						Sum(Case When Month(ORF.FecE)=12 Then Isnull(COF.Costo,0) Else 0.00 End) As Dic,
						Max(Convert(nvarchar,ORF.FecE,103)) FecE
				 from 
						CptoCostoOF COF Inner join CptoCosto CC on CC.RucE=COF.RucE and CC.Cd_Cos=COF.Cd_Cos
						inner join OrdFabricacion ORF on ORF.RucE=COF.RucE and ORF.Cd_OF=COF.Cd_OF
				 where 
						ORF.RucE=@RucE and 
						Month(ORF.FecE) between Convert(int,@FecD) and Convert(int,@FecH)
				 group by CC.Cd_Cos) as a 
					union all
				 select Max(ORF.RucE) RucE,Max(EEO.Cd_Cos) Cd_Cos,Max(CC.CodSNT_) CodSNT_
				,Sum(Case When Month(ORF.FecE)=1 Then Isnull(EEO.Costo,0) Else 0.00 End) As Ene
				,Sum(Case When Month(ORF.FecE)=2 Then Isnull(EEO.Costo,0) Else 0.00 End) As Feb
				,Sum(Case When Month(ORF.FecE)=3 Then Isnull(EEO.Costo,0) Else 0.00 End) As Mar
				,Sum(Case When Month(ORF.FecE)=4 Then Isnull(EEO.Costo,0) Else 0.00 End) As Abr
				,Sum(Case When Month(ORF.FecE)=5 Then Isnull(EEO.Costo,0) Else 0.00 End) As May
				,Sum(Case When Month(ORF.FecE)=6 Then Isnull(EEO.Costo,0) Else 0.00 End) As Jun
				,Sum(Case When Month(ORF.FecE)=7 Then Isnull(EEO.Costo,0) Else 0.00 End) As Jul
				,Sum(Case When Month(ORF.FecE)=8 Then Isnull(EEO.Costo,0) Else 0.00 End) As Ago
				,Sum(Case When Month(ORF.FecE)=9 Then Isnull(EEO.Costo,0) Else 0.00 End) As Spt
				,Sum(Case When Month(ORF.FecE)=10 Then Isnull(EEO.Costo,0) Else 0.00 End) As Oct
				,Sum(Case When Month(ORF.FecE)=11 Then Isnull(EEO.Costo,0) Else 0.00 End) As Nov
				,Sum(Case When Month(ORF.FecE)=12 Then Isnull(EEO.Costo,0) Else 0.00 End) As Dic
				,Max(Convert(nvarchar,ORF.FecE,103)) FecE
				 from EnvEmbOF EEO inner join CptoCosto CC on cc.RucE=EEO.RucE and CC.Cd_Cos=EEO.Cd_Cos
				  inner join OrdFabricacion ORF on ORF.RucE=EEO.RucE and ORF.Cd_OF=EEO.Cd_OF
				 where ORF.RucE=@RucE and Month(ORF.FecE) between Convert(int,@FecD) and Convert(int,@FecH)
				 group by CC.Cd_Cos 
					union all
				 Select Max(ORF.RucE) RucE,Max(FOF.Cd_Cos) Cd_Cos,Max(CC.CodSNT_) CodSNT_
				,Sum(Case When Month(ORF.FecE)=1 Then Isnull(FOF.Costo,0) Else 0.00 End) As Ene
				,Sum(Case When Month(ORF.FecE)=2 Then Isnull(FOF.Costo,0) Else 0.00 End) As Feb
				,Sum(Case When Month(ORF.FecE)=3 Then Isnull(FOF.Costo,0) Else 0.00 End) As Mar
				,Sum(Case When Month(ORF.FecE)=4 Then Isnull(FOF.Costo,0) Else 0.00 End) As Abr
				,Sum(Case When Month(ORF.FecE)=5 Then Isnull(FOF.Costo,0) Else 0.00 End) As May
				,Sum(Case When Month(ORF.FecE)=6 Then Isnull(FOF.Costo,0) Else 0.00 End) As Jun
				,Sum(Case When Month(ORF.FecE)=7 Then Isnull(FOF.Costo,0) Else 0.00 End) As Jul
				,Sum(Case When Month(ORF.FecE)=8 Then Isnull(FOF.Costo,0) Else 0.00 End) As Ago
				,Sum(Case When Month(ORF.FecE)=9 Then Isnull(FOF.Costo,0) Else 0.00 End) As Spt
				,Sum(Case When Month(ORF.FecE)=10 Then Isnull(FOF.Costo,0) Else 0.00 End) As Oct
				,Sum(Case When Month(ORF.FecE)=11 Then Isnull(FOF.Costo,0) Else 0.00 End) As Nov
				,Sum(Case When Month(ORF.FecE)=12 Then Isnull(FOF.Costo,0) Else 0.00 End) As Dic
				,Max(Convert(nvarchar,ORF.FecE,103)) FecE
				 from FrmlaOF FOF inner join CptoCosto CC on cc.RucE=FOF.RucE and CC.Cd_Cos=FOF.Cd_Cos
				  inner join OrdFabricacion ORF on ORF.RucE=FOF.RucE and ORF.Cd_OF=FOF.Cd_OF
				 where ORF.RucE=@RucE and Month(ORF.FecE) between Convert(int,@FecD) and Convert(int,@FecH)
				 group by CC.Cd_Cos) as b inner join CptoCosto c on c.RucE=b.RucE and c.Cd_Cos=b.Cd_Cos
			group by b.Cd_Cos
		) as t
) as z	
group By z.Cd_Cos,z.Descrip
order by Max(z.CodSNT_)
--order by Max(z.CodSNT_),Max(z.FecE)		

		-- Cabecera
		select 	@RucE RucE,
			RSocial,
			'Desde ' + @FecD+ ' Hasta ' + @FecH as Prdo 
		from 
			Empresa
		Where
		 	Ruc=@RucE
	end
----------------------LEYENDA----------------------
--JJ: 27/02/2011 <Creacion del Procedimiento Almacenado>
-- exec User321.Rpt_RegCostos '11111111111','01','05',null
GO

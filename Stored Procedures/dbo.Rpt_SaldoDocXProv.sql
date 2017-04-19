SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_SaldoDocXProv]

--Declare 

 @RucEmp nvarchar(11)
,@Ejer nvarchar(4)
,@Prdo nvarchar(2)

,@IC_Saldo nvarchar(2)

,@Cd_TD nvarchar(100)
--,@FecED smalldatetime
--,@FecVD smalldatetime

AS


--SET @RucEmp = '20100977037'
------SET @RucEmp = '20102028687'
--SET @Ejer = '2011'
--SET @Prdo = '01'
----SET @NroDoc = ''
----SET @NroSre = ''
----SET @Cd_Prv = ''
--SET @IC_Saldo = '' --00 PARA TODO 01 PARA SALDADO
----SET @Cd_MdRg = ''  --'' TODOS '01' SOLES '02' DOLARES
--SET @Cd_TD = '02'

IF @RucEmp is null SET @RucEmp  = ''
IF @Ejer is null Set @Ejer = ''
IF @Prdo is null Set @Prdo = ''

IF @IC_Saldo is null set @IC_Saldo = '00'

IF @Cd_TD is null set @Cd_TD = ''



DECLARE @Sql1 varchar(4000),@Sql2 varchar(4000)

--40.1.1.30
--40.1.1.40
--SELECT * FROM Voucher V WHERE V.NroCta LIKE '40.1.1%' AND V.Cd_TD = '02'
--and v.RucE = @RucEmp -- and v.Ejer = @Ejer 


		SELECT 
			Montos.Cd_TD+ ' | ' +td.NCorto as Cd_TD,
			isnull(pv.NDoc,'') as NDoc,
			Isnull(Montos.Cd_Prv, '') as Cd_Prv
			,pv.Cd_TDI + ' | ' +tdi.NCorto as Cd_TDI
			,isnull(pv.Rsocial, ISNULL(pv.ApPat, '') +' '+ ISNULL(pv.ApMat, '') + ' ' +ISNULL(pv.Nom, '')) as NomPrv
			,Montos.NroSre
			,Montos.NroDoc
			,Montos.Cd_MdRg + ' | ' + (CASE Montos.Cd_MdRg when '01' then 'Soles' when '02' then 'Dólares' end) as Cd_MdRg
			,(case Montos.IC_Cancel when '00' THEN 'Pendiente' WHEN '01' then 'Saldado' end) as IC_Cancel
			,(CASE Montos.Cd_MdRg when '01' then (Montos.MtoD) when '02' then Montos.MtoD_ME end) as MontoD
			,(CASE Montos.Cd_MdRg when '01' then (Montos.MtoH) when '02' then Montos.MtoH_ME END) as MontoH

			,(CASE Montos.Cd_MdRg when '01' then (Montos.MtoD) when '02' then Montos.MtoD_ME end)
			-  (CASE Montos.Cd_MdRg when '01' then (Montos.MtoH) when '02' then Montos.MtoH_ME END)  as SaldoAPagar
	--		,(Montos.MtoD_ME) as MontoD_ME
	--		,(Montos.MtoH_ME) as MontoH_ME
	--		,(Montos.MtoD_ME)-  (Montos.MtoH_ME)  as SaldoAPagar_ME 
			
			,Montos.PrdoRC
			,Montos.PrdoPago
			,Montos.FecED
			,Montos.FecVD
			
			
		FROM
			(
				SELECT 
				V.CD_TD ,
				 v.Cd_Prv, V.NroSre, v.NroDoc, 
				 MAX(case WHEN V.Cd_Fte = 'RC' and v.MtoD = 0.0 then (v.Cd_MdRg )
					when V.Cd_Fte = 'LD' and v.MtoD = 0.0 then (v.Cd_MdRg ) end) as Cd_MdRg,
				 
				 SUM( CASE WHEN V.Cd_Fte ='LD' AND v.MtoH = 0.0 AND V.MtoD > 0.0 then  V.MtoD
				 when V.Cd_Fte = 'CB' AND V.MtoH = 0.0 AND V.MtoD > 0.0 THEN V.MtoD ELSE 0.0 end  ) as MtoD
				
				 ,SUM(case WHEN V.Cd_Fte = 'RC' and v.MtoD = 0.0 AND V.MtoH > 0.0 then V.MtoH 
					when V.Cd_Fte = 'LD' and v.MtoD = 0.0 AND V.MtoH > 0.0 then V.MtoH else 0.0 end) as MtoH

				 ,SUM( CASE WHEN V.Cd_Fte ='LD' AND v.MtoH_ME = 0.0 AND V.MtoD_ME > 0.0 then  V.MtoD_ME
				 when V.Cd_Fte = 'CB' AND V.MtoH_ME = 0.0 AND V.MtoD_ME > 0.0 THEN V.MtoD_ME ELSE 0.0 end  ) as MtoD_ME
				
				 ,SUM(case WHEN V.Cd_Fte = 'RC' and v.MtoD_ME = 0.0  AND V.MtoH_ME > 0.0 then MtoH_ME 
					when V.Cd_Fte = 'LD' and v.MtoD_ME = 0.0 AND V.MtoH_ME > 0.0 then MtoH_ME else 0.0 end) as MtoH_ME
					
				,MIN((CASE WHEN V.Cd_Fte ='LD' AND v.MtoD = 0.0 then V.Prdo
				 WHEN V.Cd_Fte = 'RC' and v.MtoD = 0.0 then V.Prdo
				 end)) AS PrdoRC	
				 
				 ,MAX(CASE WHEN V.Cd_Fte ='LD' AND v.MtoH = 0.0 then  V.Prdo
				 when V.Cd_Fte = 'CB' AND V.MtoH = 0.0 THEN V.Prdo end) AS PrdoPago
				 
				 ,MAX(case WHEN V.Cd_Fte = 'RC' and v.MtoD = 0.0 then (v.FecED )
					when V.Cd_Fte = 'LD' and v.MtoD = 0.0 then (v.FecED ) else 0.0 end) as FecED
					
				 ,MAX( CASE WHEN V.Cd_Fte ='LD' AND v.MtoH = 0.0 then  ISNULL(V.FecVD,V.FECMOV)
				 when V.Cd_Fte = 'CB' AND V.MtoH = 0.0 THEN ISNULL(V.FecVD,V.FECMOV) ELSE 0.0 end  ) as FecVD			
						
						
						
						
				,CASE MAX(case WHEN V.Cd_Fte = 'RC' and v.MtoD = 0.0 then (v.Cd_MdRg )
					when V.Cd_Fte = 'LD' and v.MtoD = 0.0 then (v.Cd_MdRg ) end)
					WHEN '01' THEN 
						CASE WHEN 
							(
							 SUM( CASE WHEN V.Cd_Fte ='LD' AND v.MtoH = 0.0 AND V.MtoD > 0.0 then  V.MtoD
					 when V.Cd_Fte = 'CB' AND V.MtoH = 0.0 AND V.MtoD > 0.0 THEN V.MtoD ELSE 0.0 end  ) 
				
					 -SUM(case WHEN V.Cd_Fte = 'RC' and v.MtoD = 0.0 AND V.MtoH > 0.0 then V.MtoH 
					when V.Cd_Fte = 'LD' and v.MtoD = 0.0 AND V.MtoH > 0.0 then V.MtoH else 0.0 end) 
							
							)>= 0  THEN '01' ELSE '00' END
					
					WHEN '02' THEN 	
						CASE WHEN 
						(
						SUM( CASE WHEN V.Cd_Fte ='LD' AND v.MtoH_ME = 0.0 AND V.MtoD_ME > 0.0 then  V.MtoD_ME
				 when V.Cd_Fte = 'CB' AND V.MtoH_ME = 0.0 AND V.MtoD_ME > 0.0 THEN V.MtoD_ME ELSE 0.0 end  )
				
				 -SUM(case WHEN V.Cd_Fte = 'RC' and v.MtoD_ME = 0.0  AND V.MtoH_ME > 0.0 then MtoH_ME 
					when V.Cd_Fte = 'LD' and v.MtoD_ME = 0.0 AND V.MtoH_ME > 0.0 then MtoH_ME else 0.0 end)
						) >= 0 THEN '01' ELSE '00' END
					    
					 END	AS IC_Cancel
						
						
							


			

		
				 FROM Voucher V
				 WHERE 
				  V.RucE = @RucEmp and v.Ejer = @Ejer
				  and v.Prdo <= case @Prdo WHEN '' THEN v.Prdo else @Prdo end
				  and v.Cd_TD = (CASE @Cd_TD WHEN '' THEN v.Cd_TD  ELSE (@Cd_TD) END)
				  and v.Cd_Fte in ('RC','LD','CB')
				  GROUP by 
				  V.CD_TD,
				  V.Cd_Prv, V.NroSre, V.NroDoc    
				
			) AS Montos	
		LEFT JOIN Proveedor2 pv on pv.RucE = @RucEmp and pv.Cd_Prv = Montos.Cd_Prv
		INNER JOIN TipDoc td on td.Cd_Td = Montos.Cd_TD
		INNER JOIN TipDocIdn tdi on tdi.Cd_TDI = pv.Cd_TDI
		
		
		WHERE 

		
		 Montos.PrdoPago = CASE WHEN  @Prdo = '' THEN Montos.PrdoPago else @Prdo END

		AND Montos.IC_Cancel = CASE  @IC_Saldo WHEN '' THEN Montos.IC_Cancel else @IC_Saldo END





		GROUP BY
			Montos.Cd_TD,
			td.NCorto,
			 Montos.Cd_Prv
			,Montos.NroSre
			,Montos.NroDoc
		  
			,Montos.MtoD
			,Montos.MtoH
			,Montos.MtoD_ME
			,Montos.MtoH_ME	
			,pv.RSocial
			,pv.ApPat
			,pv.ApMat
			,pv.Nom
			,pv.Cd_TDI
			,pv.NDoc
			,tdi.NCorto
			,Montos.PrdoRC
			,Montos.PrdoPago
			,Montos.FecED
			,Montos.FecVD
			,Montos.Cd_MdRg
			 
			,Montos.IC_Cancel

			


		ORDER BY Montos.cd_td, Montos.Cd_MdRg
		
GO

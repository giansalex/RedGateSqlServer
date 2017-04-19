SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_PorPrdUM3]
--Consulta Todos los PRV con esos productos y las unidades de medida
@RucE nvarchar(11),
@Dato2 nvarchar(4000),
@Dato3 nvarchar(4000),
@NroProd int,
@msj varchar(100) output
as

declare @check bit
set @check=0

select @check as Sel, P.Cd_Prv, RucE, P.NDoc, 
case(isnull(len(RSocial),@check))when @check then ApPat +' '+ ApMat + ' ' + Nom else RSocial end as Nombre, 
TDI.NCorto as descrip,P.Correo
from(
	select count(*) as NroProd, Cd_Prv from(
		select Cd_Prv
		from ProdProv  
		where RucE = @RucE and (''''+Cd_Prod + '' + convert(nvarchar,Id_UMP)+'''') in(@Dato2) 
		union
		select Cd_Prv
		from ServProv  
		where RucE = @RucE and Cd_Srv in(@Dato3)
	) as tabla
	group by Cd_Prv
) as Prov
join Proveedor2 as P on P.RucE = @RucE and Prov.Cd_Prv = P.Cd_Prv 
join TipDocIdn TDI on P.Cd_TDI = TDI.Cd_TDI  where NroProd = @NroProd

--	LEYENDA
/*	MM : <14/09/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_Proveedor2Cons_PorPrdUM2 '11111111111','''PD000121''','',1, null
	
*/
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

-- Se copio sintaxis de  Vta_CotizacionConsClienteDatos_X_CdCot
CREATE procedure [user321].[Vta_VtaxCltCons_xVta]
@RucE nvarchar(11),
@Cd_Vta varchar(20),
@msj varchar(100) output
as
if not exists (select TOP 1 Cd_Clt from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	Set @msj = 'No existe Cliente en Venta.'
else
begin
select EC.RucE,Ec.Cd_TDI,EC.NDoc as 'NDoc',EC.RSocialContacto as 'RSocialContacto',Correo ,ec.Tipo,ec.Cd_Clt,C.Cd_Vta
from
(
	  select RucE,null as 'Cd_TDI' ,isnull(Convert(varchar(15),null),null) as NDoc ,Convert(varchar(10),ID_Gen) as Cd_Clt,
	  Cd_Clt as 'CodCliente',Convert(varchar(150),ApPat +' '+ ApMat +', '+Nom) as RSocialContacto,
	  Correo,
	  'Correo Contacto' as Tipo   
	  from Contacto
	 where RucE=@RucE 
	  union all
	  select RucE,tdi.Cd_TDI as 'Cd_TDI' ,Convert(varchar(15),NDoc),Cd_Clt,Cd_Clt as 'CodCliente',RSocial,
	  Correo,
	  'Correo Principal' as Tipo 	   
	  from Cliente2 c
	  inner join TipDocIdn tdi on tdi.Cd_TDI= c.Cd_TDI
  where RucE=@RucE
 ) as  EC
inner join venta C  on C.RucE=EC.RucE and EC.CodCliente=c.Cd_Clt 
where c.RucE=@RucE and c.Cd_Vta=@Cd_Vta 
order by c.Cd_Clt
end


-- 05/01/2017  --> Se creo este pro



GO

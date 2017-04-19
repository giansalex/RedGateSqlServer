SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

-- Se copio sintaxis de  Vta_CotizacionConsClienteDatos_X_CdCot
CREATE procedure [user321].[Vta_CotxCltCons_xCotVta]
@RucE nvarchar(11),
@Cd_Cot varchar(20),
@msj varchar(100) output
as
if not exists (select TOP 1 Cd_Clt from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot)
	Set @msj = 'No existe Cliente en Cotizacion'
else
begin
select EC.RucE,Ec.Cd_TDI,EC.NDoc as 'NDoc',EC.RSocialContacto as 'RSocialContacto',Correo ,ec.Tipo,ec.Cd_Clt,C.Cd_Cot
from
(
	  select RucE,null as 'Cd_TDI' ,Convert(varchar(15),null) as NDoc ,Convert(varchar(10),ID_Gen) as Cd_Clt,
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
inner join Cotizacion C  on C.RucE=EC.RucE and EC.CodCliente=c.Cd_Clt 
where c.RucE=@RucE and c.Cd_Cot=@Cd_Cot 
order by c.Cd_Clt
end


-- 05/01/2017  --> Se creo este pro



GO

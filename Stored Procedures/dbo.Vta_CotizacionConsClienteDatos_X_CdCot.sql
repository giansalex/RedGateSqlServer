SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- columnas : N° DOC. | TIPO 'EMPRESA O CONTACTO' | RAZON SOCIAL O CONTACTO  | CORREO 

CREATE PROCEDURE [dbo].[Vta_CotizacionConsClienteDatos_X_CdCot]
@RucE nvarchar(11),
@Cd_Cot varchar(20),
@msj varchar(100) output
as
if not exists (select TOP 1 Cd_Clt from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot)
	Set @msj = 'No existe Cliente en Cotizacion'
else
begin
select EC.RucE,EC.NDoc as 'NDoc',EC.RSocialContacto as 'RSocial',Correo 
from
(
	  select RucE,Convert(varchar(15),null) as NDoc ,Convert(varchar(10),ID_Gen) as Codigo,Cd_Clt as 'CodCliente',Convert(varchar(150),ApPat +' '+ ApMat +', '+Nom) as RSocialContacto,Correo  
	  from Contacto
	 where RucE=@RucE 
	  union all
	  select RucE,Convert(varchar(15),NDoc),Cd_Clt,Cd_Clt as 'CodCliente',RSocial,Correo  
	  from Cliente2
  where RucE=@RucE
 ) as  EC
inner join Cotizacion C  on C.RucE=EC.RucE and EC.CodCliente=c.Cd_Clt 
where c.RucE=@RucE and c.Cd_Cot=@Cd_Cot 
order by Cd_Clt
end




GO

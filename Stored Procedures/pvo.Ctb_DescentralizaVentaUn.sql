SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [pvo].[Ctb_DescentralizaVentaUn]
@RucE nvarchar(11),
@Ejer nvarchar(4), 
@RegCtb nvarchar(15),
@IB_Forzar bit, -- Fuerza si es que un docuemto ya exite y aun asi se desea desentralizar
@Ind_OK varchar(10) output,
@msj varchar(100) output
as

print @msj

-- PRUEBAS ---------------
/*

*/

------------------------


--PV: Jue 13/08/09  --> Creado


GO

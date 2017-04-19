SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_CtaXCob_Explo_CodVta]

@RucE nvarchar(11),
@Cd_TD nvarchar(2),
@NroDoc nvarchar(11),
@NroSre nvarchar(11),
@Ejer nvarchar(4)
as
--set @RucE = '11111111111'
--set @Cd_TD = '01'
--set @NroDoc = '0000253'
--set @NroSre =''
--set @Ejer = '2011'

select RucE, Eje, Cd_Vta,NroDoc,NroSre,Cd_Td from Venta 
where 
RucE = @RucE
and Eje = @Ejer 
and Cd_Td = @Cd_TD
and case when isnull(@NroSre,'') <> '' then NroSre else '' end =  isnull(@NroSre,'')
and NroDoc = @NroDoc

--create JA: <20/02/2012>
--exec Rpt_CtaXCob_Explo_CodVta '11111111111','01','0000253','','2011'
GO

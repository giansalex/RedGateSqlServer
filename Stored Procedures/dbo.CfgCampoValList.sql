SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[CfgCampoValList] @RucEmp nvarchar(11), @Id_TDt int, @Id_CTb int

/*
Set @RucEmp = '20102028687'
Set @Id_TDt = 7
Set @Id_CTb = 16
*/
as
Select 	con.*	from 	CfgCampos con 
		        where con.RucE = @RucEmp and con.Id_CTb = @Id_CTb and con.Id_TDt = @Id_TDt and con.IB_Hab = '1'

--<Created RG |16/02/2013|>


--select * from CfgCampos where RucE = '20101588930'
GO

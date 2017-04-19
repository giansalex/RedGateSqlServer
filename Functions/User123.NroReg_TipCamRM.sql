SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[NroReg_TipCamRM]()
returns int AS
begin 
      return (select isnull(Max(NroReg),0)+1 from TipCamRM )

end
GO

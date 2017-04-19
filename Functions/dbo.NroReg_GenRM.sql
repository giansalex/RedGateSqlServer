SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NroReg_GenRM](@RucE nvarchar(11))
returns int AS
begin 
      return (select isnull(Max(NroReg),0)+1 from GeneralRM where RucE=@RucE)

end

GO

CREATE TABLE [dbo].[AuxiliarRM]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroReg] [int] NOT NULL,
[Cd_Aux] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TDI] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroDoc] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TA] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Usu] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecMov] [datetime] NOT NULL,
[Cd_Est] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuxiliarRM] ADD CONSTRAINT [PK_AuxiliarRM] PRIMARY KEY CLUSTERED  ([RucE], [NroReg]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuxiliarRM] WITH NOCHECK ADD CONSTRAINT [FK_AuxiliarRM_Estado] FOREIGN KEY ([Cd_Est]) REFERENCES [dbo].[Estado] ([Cd_Est])
GO
ALTER TABLE [dbo].[AuxiliarRM] ADD CONSTRAINT [FK_AuxiliarRM_Modulo] FOREIGN KEY ([Cd_MR]) REFERENCES [dbo].[Modulo] ([Cd_MR])
GO
ALTER TABLE [dbo].[AuxiliarRM] WITH NOCHECK ADD CONSTRAINT [FK_AuxiliarRM_TipAux] FOREIGN KEY ([Cd_TA]) REFERENCES [dbo].[TipAux] ([Cd_TA])
GO
ALTER TABLE [dbo].[AuxiliarRM] WITH NOCHECK ADD CONSTRAINT [FK_AuxiliarRM_TipDocIdn] FOREIGN KEY ([Cd_TDI]) REFERENCES [dbo].[TipDocIdn] ([Cd_TDI])
GO
ALTER TABLE [dbo].[AuxiliarRM] WITH NOCHECK ADD CONSTRAINT [FK_AuxiliarRM_Usuario] FOREIGN KEY ([Usu]) REFERENCES [dbo].[Usuario] ([NomUsu])
GO

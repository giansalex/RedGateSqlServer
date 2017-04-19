CREATE TABLE [dbo].[AccesoM]
(
[Cd_GA] [int] NOT NULL,
[Cd_MN] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccesoM] ADD CONSTRAINT [IX_AccesoM] UNIQUE NONCLUSTERED  ([Cd_GA], [Cd_MN]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccesoM] WITH NOCHECK ADD CONSTRAINT [FK_AccesoM_GrupoAcceso] FOREIGN KEY ([Cd_GA]) REFERENCES [dbo].[GrupoAcceso] ([Cd_GA])
GO
ALTER TABLE [dbo].[AccesoM] WITH NOCHECK ADD CONSTRAINT [FK_AccesoM_Menu] FOREIGN KEY ([Cd_MN]) REFERENCES [dbo].[Menu] ([Cd_MN]) ON UPDATE CASCADE
GO

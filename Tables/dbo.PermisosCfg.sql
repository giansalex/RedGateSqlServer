CREATE TABLE [dbo].[PermisosCfg]
(
[Cd_CfgPm] [smallint] NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Pm01] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm02] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm03] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm04] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm05] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm06] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm07] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm08] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm09] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Pm10] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermisosCfg] ADD CONSTRAINT [PK_PermisosCfg] PRIMARY KEY CLUSTERED  ([Cd_CfgPm]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermisosCfg] ADD CONSTRAINT [IX_PermisosCfg] UNIQUE NONCLUSTERED  ([Pm01], [Pm02], [Pm03], [Pm04], [Pm05], [Pm06], [Pm07], [Pm08], [Pm09], [Pm10]) ON [PRIMARY]
GO
